class AddRatingToLandmnarkDescriptions < ActiveRecord::Migration
  def change
    add_column :abstract_descriptions, :rating, :real, default: 0
  end
end
