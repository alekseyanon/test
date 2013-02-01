class RatingsController < InheritedResources::Base

	def create
		if current_user.nil?
			render json: { error: "login please" }
		else
			create_landmark_description_rating(params)
		end
	end

	def create_landmark_description_rating(params)
		ld = LandmarkDescription.find(params[:idBox])
		if ld.user_vote_present?(current_user.id)
			rating = current_user.ratings.with_landmark_id(ld)
			rating.value = params[:rate]
			if rating.save
				render json: { rating: params[:rate]}
			else
				render json: { error: "error"}
			end
		else
			rating = ld.ratings.build(value: params[:rate])
		  rating.user = current_user
		  if rating.save
				render json: { rating: params[:rate]}
			else
				render json: {error: "error"}
			end
		end
	end

end
