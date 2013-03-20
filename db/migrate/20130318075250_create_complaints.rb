class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.text :content
      t.references :user
      t.references :complaintable, polymorphic: true

      t.timestamps
    end
    add_index :complaints, :user_id
  end
end
