require 'spec_helper'

describe Api::CommentsController do

  let!(:review){Review.make!}

  login_user

  def valid_attributes
    { 'body' => 'MyText'}
  end

  describe 'POST create with valid params' do
    it 'creates a new Comment' do
      expect {
        post :create, {format: 'json', comment: valid_attributes, review_id: review.id}
      }.to change(Comment, :count).by(1)
    end
  end

end
