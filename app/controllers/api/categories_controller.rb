class Api::CategoriesController < ApplicationController
  respond_to :json
  # "created_at", "description", "lft", "rgt", "updated_at"
  def index
    respond_with Category.root ? Category.root.descendants : []
  end

end
