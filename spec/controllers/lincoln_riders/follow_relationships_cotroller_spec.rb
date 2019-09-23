require 'rails_helper'


RSpec.feature "posts_controllerに関する", type: :feature do
	before do
		@user1 = FactoryBot.create(:user, :create_with_posts)
		@user2 = FactoryBot.create(:user, :create_with_posts)
		login(@user1)
	end
	feature "createした時" do
		scenario "postの編集ページ" do
			visit lincoln_riders_user_path(@user2)
			expect {
				find("a[id='follow_create']").click
			}.to change(@user1.following_users, :count).by(1)
		end
	end
	feature "destroyした時" do
		before do
			visit lincoln_riders_user_path(@user2)
			find("a[id='follow_create']").click
		end
		scenario "postの編集ページ" do
			expect {
				find("a[id='follow_destroy']").click
			}.to change(@user1.following_users, :count).by(-1)
		end
	end
end