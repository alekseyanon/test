class Api::CategoriesController < ApplicationController
  respond_to :json

  def index
    respond_with Category.root ? Category.root.descendants : []
  end

end
