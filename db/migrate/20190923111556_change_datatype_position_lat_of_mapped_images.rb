class ChangeDatatypePositionLatOfMappedImages < ActiveRecord::Migration[5.2]
  def change
  	change_column :mapped_images, :position_lat, :float
  end
end
