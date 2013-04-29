require 'spec_helper'

describe Api::CategoriesController do

  describe "GET 'index'" do
    it "returns categories in json" do
      root = Category.make!
      c1 = Category.make!
      c2 = Category.make!
      c1.move_to_child_of root
      c2.move_to_child_of root
      get :index, format: :json
      response.should be_success
      body = response.body
      JSON.parse(body)
      body.should have_content c1.name_ru
      body.should have_content c2.name_ru
    end
  end

end
