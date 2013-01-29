class RatingsController < InheritedResources::Base

	def create
		if current_user.anonymous?
			render json: { redirect: "login please" }
		else
			create_landmark_description_rating(params)
		end
	end

	def create_landmark_description_rating(params)
		ld = LandmarkDescription.find(params[:idBox])
		if ld.user_vote_present?(current_user.id)
		  rating = ld.ratings.build(value: params[:rate])
		  rating.user = current_user
		  if rating.save
				render json: { rating: params[:rate]}
			else
				render json: {error: "error"}
			end
		else
			rating = current_user.landmark_description_rating(ld)
			rating.value = params[:rate]
			if rating.save
				render json: { rating: params[:rate]}
			else
				render json: {error: "error"}
			end
		end
	end

end
