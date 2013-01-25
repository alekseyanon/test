require 'spec_helper'

describe "LmRatings" do
  context "check rating for new object" do
  	before :each do
  		@ld = LandmarkDescription.make!
  	end

    ### TODO: Not working JS => TRUE with visit landmark_description_path(@ld)
    it "rating is present"
    #  do
    # 	visit landmark_description_path(@ld)
    # 	str = "\#0_#{@ld.id}_1"
    # 	page.should have_selector('.user-rating')
    # 	page.should have_selector(str)
    # end

    it "rating is changed" 
  end
end
