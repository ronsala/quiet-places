class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :user_id
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :category
      t.string :website

      t.timestamps null: false
    end
  end
end
