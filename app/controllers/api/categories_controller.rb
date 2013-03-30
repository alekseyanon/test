class Api::CategoriesController < ApplicationController
  respond_to :json

  def index
    main_cat = Category.find_by_name_ru 'Категории географических объектов'
    respond_with main_cat.descendants
  end

end
