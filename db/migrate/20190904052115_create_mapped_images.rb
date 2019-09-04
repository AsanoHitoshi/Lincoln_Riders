class CreateMappedImages < ActiveRecord::Migration[5.2]
  def change
    create_table :mapped_images do |t|
      t.text :text,null: false
      t.text :image_id
      t.string :position_lat
      t.string :position_lng
      t.integer :user_id
      t.timestamps
    end
  end
end
