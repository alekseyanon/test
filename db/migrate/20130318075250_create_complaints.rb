class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.text :content
      t.references :user
      t.integer :complaintable_id
      t.string :complaintable_type

      t.timestamps
    end
    add_index :complaints, :user_id
  end
end
