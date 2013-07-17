require 'spec_helper'

describe Api::ReviewsController do

  let!(:ld){GeoObject.make!}
  login_user

  def valid_attributes
    { title: Faker::Lorem.sentence,
      body:  Faker::Lorem.sentences(10)
    }
  end

  describe 'POST create with valid params' do
    it 'creates a new Review' do
      check_create Review, {geo_object_id: ld.id, review: valid_attributes}
    end
  end

end
