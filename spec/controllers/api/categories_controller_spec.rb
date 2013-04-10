require 'spec_helper'

describe Api::CategoriesController do

  describe "GET 'index'" do
    it "returns http success" do
      load_categories
      get :index, format: :json
      response.should be_success
      JSON.parse(response.body)
      response.body.should have_content 'nature'
    end
  end

end
