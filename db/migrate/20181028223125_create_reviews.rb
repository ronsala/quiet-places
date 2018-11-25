class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :place_id
      t.string :title
      t.boolean :tv
      t.integer :volume
      t.integer :quality
      t.text :body

      t.timestamps null: false
    end
  end
end
