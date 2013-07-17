require 'spec_helper'

describe Api::ComplaintsController do

  let!(:review){Review.make!}

  login_user

  def valid_attributes
    { 'content' => 'MyText'}
  end

  describe 'POST create with valid params' do
    it 'creates a new Complaint' do
      expect {
        post :create, {format: 'json', complaint: valid_attributes, review_id: review.id}
      }.to change(Complaint, :count).by(1)
    end
  end

end
