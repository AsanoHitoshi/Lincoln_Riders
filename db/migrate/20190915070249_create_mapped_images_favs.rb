class CreateMappedImagesFavs < ActiveRecord::Migration[5.2]
  def change
    create_table :mapped_images_favs do |t|

      t.integer :user_id
      t.integer :mapped_image_id
      t.timestamps
    end
  end
end
