class VotesController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :find_voteable_model

  def create
    (params[:sign] == "up") ?
        current_user.vote_exclusively_for(@voteable) :
        current_user.vote_exclusively_against(@voteable)
    if (current_user.voted_on?(@voteable))
      render json: { positive: "#{@voteable.votes_for}", negative: "#{@voteable.votes_against}" }
    else
      request_logger params, 'Message: Check controller name, controller method for find voteable model'
    end
  end

  def destroy
    current_user.unvote_for(@voteable)
    if (current_user.voted_on?(@voteable))
      request_logger params,  'Message: Check controller name, controller method for find voteable model'
    else
      render json: { positive: "#{@voteable.votes_for}", negative: "#{@voteable.votes_against}" }
    end
  end

  private

    def find_voteable_model
      [[:comment_id, Comment],
       [:review_id, Review],
       [:image_id, Image] ].each do |(key, voteable_class)|
        return @voteable = voteable_class.find(params[key]) if params.has_key? key
      end
    end
end
