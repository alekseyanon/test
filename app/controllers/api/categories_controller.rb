class Api::CategoriesController < ApplicationController
  respond_to :json

  def index
    if Category.root
    	respond_with Category.root.descendants
    else
    	respond_with []
    end
  end

end
