require 'rails_helper'


RSpec.feature "post_favs_controllerに関する", type: :feature do
	before do
		@user1 = FactoryBot.create(:user, :create_with_posts)
		@user2 = FactoryBot.create(:user, :create_with_posts)
		login(@user1)
		@my_post = @user1.posts.first
	end
	feature "createした時" do
		before do
			visit lincoln_riders_post_path(@my_post)
		end
		scenario "作成できているか" do
			expect {
				find("a[id='post_fav_create']").click
			}.to change(@user1.fav_posts, :count).by(1)
		end
	end
	feature "destroyをクリックした時" do
		before do
			post_fav = PostFav.new(user_id: @user1.id, post_id:@my_post.id)
			post_fav.save
			visit lincoln_riders_post_path(@my_post)
		end
		scenario "削除できているか" do
			expect {
				find("a[class='post_fav_deatroy']").click
			}.to change(@user1.fav_posts, :count).by(-1)
			sleep 10
            expect(page).to have_content @my_post.user.name
		end
	end
end