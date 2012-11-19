class AddNameRuToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :name_ru, :string
  end
end
