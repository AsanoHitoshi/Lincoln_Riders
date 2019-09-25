require 'rails_helper'


RSpec.feature "mapped_images_favs_controllerに関する", type: :feature do
	before do
		@user1 = FactoryBot.create(:user, :create_with_mapped_images)
		@user2 = FactoryBot.create(:user, :create_with_mapped_images)
		login(@user1)
		@my_mapped_image = @user1.mapped_images.first
	end
	feature "createした時" do
		before do
			visit lincoln_riders_mapped_image_path(@my_mapped_image)
		end
		scenario "作成できているか" do
			expect {
				find("a[class='mapped_images_fav_create']").click
			}.to change(@user1.fav_mapped_images, :count).by(1)
		end
	end
	feature "destroyをクリックした時" do
		before do
			mapped_image_fav = MappedImagesFav.new(user_id: @user1.id, mapped_image_id: @my_mapped_image.id)
			mapped_image_fav.save
			visit lincoln_riders_mapped_image_path(@my_mapped_image)
		end
		scenario "削除できているか" do
			expect {
				find("a[class='mapped_images_fav_deatroy']").click
			}.to change(@user1.fav_mapped_images, :count).by(-1)
		end
	end
end