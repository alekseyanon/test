require 'spec_helper'

describe Api::ComplaintsController do

  let!(:review){Review.make!}
  login_user

  def valid_attributes
    { 'content' => 'MyText'}
  end

  describe 'POST create with valid params' do
    it 'creates a new Complaint' do
      check_create Complaint, {complaint: valid_attributes, review_id: review.id}
    end
  end

end
