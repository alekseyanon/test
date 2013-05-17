class VotesController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :find_parent_model

  def create
    tag = params[:voteable_tag].blank? ? nil : params[:voteable_tag]
    current_user.vote(@parent, exclusive: true, direction: params[:sign].to_sym, tag: tag)
    if current_user.voted_on?(@parent, tag)
      render json: {positive: @parent.votes_for(tag), negative: @parent.votes_against(tag), user_vote: current_user.get_vote(@parent)}
      if @parent.respond_to?(:rating) && @parent.respond_to?(:leaf_categories) 
        ### TODO leaf_categories метод имеется только у GeoObject
        @parent.update_attributes(rating: (@parent.plusminus.to_f / @parent.leaf_categories.count))
      end
    else
      request_logger params, 'Message: Check controller name, controller method for find voteable model'
    end
  end

  def destroy
    tag = params[:voteable_tag].blank? ? nil : params[:voteable_tag]
    current_user.unvote_for(@parent, tag)
    if current_user.voted_on?(@parent, tag)
      request_logger params,  'Message: Check controller name, controller method for find voteable model'
    else
      render json: {positive: @parent.votes_for(tag), negative: @parent.votes_against(tag), user_vote: current_user.get_vote(@parent)}
      if @parent.respond_to?(:rating)
        # TODO leaf_categories метод имеется только у GeoObject
        @parent.update_attributes(rating: (@parent.plusminus.to_f / @parent.leaf_categories.count))
      end
    end
  end

  private

    def find_voteable_model
      [[:comment_id, Comment],
       [:review_id, Review],
       [:image_id, Image],
       [:event_id, Event],
       [:geo_object_id, GeoObject]].each do |(key, voteable_class)|
        return @parent = voteable_class.find(params[key]) if params.has_key? key
      end
    end
end
