class LmRatingsController < InheritedResources::Base

	def create
		if current_user.anonymous?
			# redirect_to profile_path(type: 'traveler')
			render json: { redirect: "login please" }
		else
			(params[:typeBox].to_i == 1) ? create_landmark_description_rating(params) : create_review_rating(params)
		end
	end

	def create_landmark_description_rating(params)
		ld = LandmarkDescription.find(params[:idBox])
		if ld.user_vote_present?(current_user.id)
			lm = LmRating.new
		  lm.user = current_user
		  lm.value = params[:rate]
		  lm.landmark_description = ld
		  if lm.save
				render json: { rating: params[:rate]}
			else
				render json: {error: "error"}
			end
		else
			lm = current_user.ld_rating(ld)
			lm.value = params[:rate]
			if lm.save
				render json: { rating: params[:rate]}
			else
				render json: {error: "error"}
			end
		end
	end

	def create_review_rating(params)
		redirect_to root_path
	end

end
