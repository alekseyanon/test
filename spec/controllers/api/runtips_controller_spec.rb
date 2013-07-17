require 'spec_helper'

describe Api::RuntipsController do

  let!(:ld){GeoObject.make!}
  login_user

  def valid_attributes
    {body:  Faker::Lorem.sentences(10)}
  end

  describe 'POST create with valid params' do
    it 'creates a new Runtip' do
      check_create Runtip, {geo_object_id: ld.id, runtip: valid_attributes}
    end
  end

end
