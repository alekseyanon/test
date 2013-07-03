class AddSurnameToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :surname, :string
  end
end
