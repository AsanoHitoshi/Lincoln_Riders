class ChangeDatatypePositionLngOfMappedImages < ActiveRecord::Migration[5.2]
  def change
  	change_column :mapped_images, :position_lng, :float
  end
end
