class CreateMappedImages < ActiveRecord::Migration[5.2]
  def change
    create_table :mapped_images do |t|

      t.timestamps
    end
  end
end
