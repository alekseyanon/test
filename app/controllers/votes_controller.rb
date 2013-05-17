class VotesController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :find_parent_model

  def create
    tag = params[:voteable_tag].blank? ? nil : params[:voteable_tag]
    old_rating = @parent.plusminus
    current_user.vote(@parent, exclusive: true, direction: params[:sign].to_sym, tag: tag)
    new_rating = @parent.plusminus
    unless old_rating == new_rating
      respond_to do |format|
        format.html { redirect_to :back}
        format.js 
        format.json {render json: {positive: @parent.votes_for(tag), negative: @parent.votes_against(tag)}}
      end
      if @parent.respond_to?(:rating)
        ### TODO leaf_categories метод имеется только у GeoObject
        @parent.update_attributes(rating: (@parent.plusminus.to_f / @parent.leaf_categories.count))
      end
      @parent.user.update_rating(@parent, new_rating - old_rating)
    end
  end

  def destroy
    tag = params[:voteable_tag].blank? ? nil : params[:voteable_tag]
    old_rating = @parent.plusminus
    current_user.unvote_for(@parent, tag)
    new_rating = @parent.plusminus
    if current_user.voted_on?(@parent, tag)
      request_logger params,  'Message: Check controller name, controller method for find voteable model'
    else
      render json: {positive: @parent.votes_for(tag), negative: @parent.votes_against(tag)}
      if @parent.respond_to?(:rating)
        ### TODO leaf_categories метод имеется только у GeoObject
        @parent.update_attributes(rating: (@parent.plusminus.to_f / @parent.leaf_categories.count))
      end
      @parent.user.update_rating(@parent, new_rating - old_rating)
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
