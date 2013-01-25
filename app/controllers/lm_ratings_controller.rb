class LmRatingsController < InheritedResources::Base

	def create
		logger.debug "=================== CREATE LM-RaTING PARAMS ========="
		logger.debug params
		if current_user.anonymous?
			# redirect_to profile_path(type: 'traveler')
			logger.debug "================ YOU ARE ANONYMOUS ============="
			render json: { redirect: "login please" }
		else
			(params[:typeBox].to_i == 1) ? create_landmark_description_rating(params) : create_review_rating(params)
		end
	end

	def create_landmark_description_rating(params)
		logger.debug "=================== WE ARE IN THE CREATING LD METHOD ======"
		ld = LandmarkDescription.find(params[:idBox])
		if ld.user_vote_present?(current_user.id)
			lm = LmRating.new
		  lm.user = current_user
		  lm.value = params[:rate]
		  lm.landmark_description = ld
		  if lm.save
				logger.debug "=================== OOOOOOOOOOKKKKKK ======"
				render json: { rating: params[:rate]}
			else
				logger.debug "=================== FFFAAAAAAALLSSEE ======"
				render json: {error: "error"}
			end
		else
			logger.debug "=========== you are already voting ========="
			lm = current_user.ld_rating(ld)
			lm.value = params[:rate]
			if lm.save
				logger.debug "=================== OOOOOOOOOOKKKKKK new rating ======"
				render json: { rating: params[:rate]}
			else
				logger.debug "=================== FFFAAAAAAALLSSEE new rating ======"
				render json: {error: "error"}
			end
		end
	end

	def create_review_rating(params)
		logger.debug "=================== WE ARE IN THE CREATING REVIEW METHOD ======"
		redirect_to root_path
	end

end
