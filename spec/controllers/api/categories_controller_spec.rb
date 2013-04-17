require 'spec_helper'

describe Api::CategoriesController do

  describe "GET 'index'" do
    it "returns http success" do
      root = Category.make!
      c = Category.make!
      c.move_to_child_of root
      get :index, format: :json
      response.should be_success
      JSON.parse(response.body)
      response.body.should have_content c.name_ru
    end
  end

end
