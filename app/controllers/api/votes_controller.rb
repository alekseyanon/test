class Api::VotesController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :find_parent_model

  before_filter :get_tag
  before_filter :get_sign, only: :create

  def index
  end

  def create
    old_rating, new_rating = old_and_new_rating do
      current_user.vote(@parent,
                        exclusive: true,
                        direction: @sign,
                        tag: @tag)
    end
    unless old_rating == new_rating
      render_json
      update_rating old_rating, new_rating
    end
  end

  def destroy
    old_rating, new_rating = old_and_new_rating do
      current_user.unvote_for @parent, @tag
    end
    if current_user.voted_on? @parent, @tag
      request_logger params, 'Message: Check controller name, controller method for find voteable model'
    else
      render_json
      update_rating old_rating, new_rating
    end
  end

  def render_json
    render json: {positive: @parent.votes_for(@tag),
                  negative: @parent.votes_against(@tag),
                  user_vote: current_user.get_vote(@parent, @tag)}
  end

  def get_tag
    @tag = params[:voteable_tag]
  end

  def get_sign
    @sign = params[:sign] == 'up' ? :up : :down
  end

  def old_and_new_rating
    old_rating = @parent.plusminus
    yield
    [old_rating, @parent.plusminus]
  end

  def update_rating(old, new)
    if @parent.respond_to?(:rating) && @parent.is_a?(GeoObject)
      # TODO leaf_categories метод имеется только у GeoObject
      @parent.update_attributes rating: (@parent.plusminus.to_f / @parent.leaf_categories.count)
    end
    @parent.user.update_rating(@parent, new - old)
  end
end
