class VotesController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :find_voteable_model

  def create
    tag = params[:voteable_tag].blank? ? nil : params[:voteable_tag]
    if (params[:sign] == "up")
      current_user.vote_exclusively_for(@voteable, tag)
    else
      current_user.vote_exclusively_against(@voteable, tag)
    end
    if (current_user.voted_on?(@voteable, tag))
      render json: { positive: "#{@voteable.votes_for(tag)}", negative: "#{@voteable.votes_against(tag)}" }
    else
      request_logger params, 'Message: Check controller name, controller method for find voteable model'
    end
  end

  def destroy
    tag = params[:voteable_tag].blank? ? nil : params[:voteable_tag]
    current_user.unvote_for(@voteable, tag)
    if (current_user.voted_on?(@voteable, tag))
      request_logger params,  'Message: Check controller name, controller method for find voteable model'
    else
      render json: { positive: "#{@voteable.votes_for(tag)}", negative: "#{@voteable.votes_against(tag)}" }
    end
  end

  private

    def find_voteable_model
      [[:comment_id, Comment],
       [:review_id, Review],
       [:image_id, Image],
       [:landmark_description_id, LandmarkDescription]].each do |(key, voteable_class)|
        return @voteable = voteable_class.find(params[key]) if params.has_key? key
      end
    end
end
