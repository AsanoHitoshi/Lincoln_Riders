require 'rails_helper'
require "refile/file_double"


RSpec.feature "users_controllerに関する", type: :feature do
	before do
		@user1 = FactoryBot.create(:user, :create_with_mapped_images, :create_with_posts)
		@user2 = FactoryBot.create(:user, :create_with_mapped_images, :create_with_posts)
		@my_mapped_image = @user1.mapped_images.first
		@my_post = @user1.posts.first
		@other_mapped_image = @user2.mapped_images.first
		@other_post = @user2.posts.first
	end

	feature "ログインしていない状態でアクセスした場合" do
		before do
			sign_out(@user1)
		end
		feature "mypage" do
			before do
				visit lincoln_riders_user_mypage_path
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "mypage_post" do
			before do
				visit lincoln_riders_user_mypage_posts_path
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "mypage_fav_post" do
			before do
				visit lincoln_riders_user_mypage_fav_posts_path
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "mypage_mapped_image" do
			before do
				visit lincoln_riders_user_mypage_mapped_images_path
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "mypage_fav_mapped_image" do
			before do
				visit lincoln_riders_user_mypage_fav_mapped_images_path
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "show" do
			before do
				visit lincoln_riders_user_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "show_post" do
			before do
				visit lincoln_riders_user_show_posts_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "show_fav_post" do
			before do
				visit lincoln_riders_user_show_fav_posts_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "show_mapped_image" do
			before do
				visit lincoln_riders_user_show_mapped_images_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "show_fav_mapped_image" do
			before do
				visit lincoln_riders_user_show_fav_mapped_images_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "following_user_index" do
			before do
				visit following_users_index_lincoln_riders_user_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "followed_user_index" do
			before do
				visit followed_users_index_lincoln_riders_user_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
		feature "edit" do
			before do
				visit edit_lincoln_riders_user_path(@user1)
			end
			scenario "リダイレクト先の確認" do
				expect(page).to have_current_path new_user_session_path
			end
		end
	end
	feature "ログインしている状態でアクセスした場合" do
		before do
			login(@user2)
				# @user2が@user1をフォローする
				visit lincoln_riders_user_path(@user1)
				find("a[id='follow_create']").click
				# @user2が@user1のPostをいいねする
				visit lincoln_riders_post_path(@my_post)
				find("a[id='post_fav_create']").click
				# @user2が@user1のMappedImageをいいねする
				visit lincoln_riders_mapped_image_path(@my_mapped_image)
				find("a[class='mapped_images_fav_create']").click
			sign_out(@user2)
			login(@user1)
				# @user1が@user2をフォローする
				visit lincoln_riders_user_path(@user2)
				find("a[id='follow_create']").click
				# @user1が@user2のPostをいいねする
				visit lincoln_riders_post_path(@other_post)
				find("a[id='post_fav_create']").click
				# @user1が@user2のMappedImageをいいねする
				visit lincoln_riders_mapped_image_path(@other_mapped_image)
				find("a[class='mapped_images_fav_create']").click
		end
		feature "mypage" do
			before do
				visit lincoln_riders_user_mypage_path
			end
			scenario "表示内容の確認" do
				following_users = @user1.following_users

				following_users_id = following_users.pluck(:id)
				shown_user_id = following_users_id.push(@user1.id)

				latest_posts = Post.where(user_id: shown_user_id)
				latest_posts = latest_posts.order(id: "DESC").limit(5)
				latest_posts.each do |post|
					expect(page).to have_content post.user.name
					expect(page).to have_content post.text
				end


				latest_mapped_images = MappedImage.where(user_id: shown_user_id)
				latest_mapped_images = latest_mapped_images.order(id: "DESC").limit(5)
				latest_mapped_images.each do |mapped_image|
					expect(page).to have_content mapped_image.user.name
					expect(page).to have_content mapped_image.text
				end
			end
		end
		feature "mypage_post" do
			before do
				visit lincoln_riders_user_mypage_posts_path
			end
			scenario "表示内容の確認" do

				my_posts = @user1.posts
				my_posts.each do |post|
					expect(page).to have_content post.user.name
					expect(page).to have_content post.text
				end

				follow_users = @user1.following_users
				follow_users.each do |follow_user|
					follow_user.posts.each do |post|
						expect(page).to have_content post.user.name
						expect(page).to have_content post.text
					end
				end

			end
		end
		feature "mypage_fav_post" do
			before do
				visit lincoln_riders_user_mypage_fav_posts_path
			end
			scenario "表示内容の確認" do
				my_fav_posts = @user1.fav_posts
				my_fav_posts.each do |post|
					expect(page).to have_content post.user.name
					expect(page).to have_content post.text
				end
			end
		end
		feature "mypage_mapped_image" do
			before do
				visit lincoln_riders_user_mypage_mapped_images_path
			end
			scenario "表示内容の確認" do
				my_mapped_images = @user1.mapped_images
				my_mapped_images.each do |mapped_image|
					expect(page).to have_content mapped_image.user.name
					expect(page).to have_content mapped_image.text
				end

				follow_users = @user1.following_users
				follow_users.each do |follow_user|
					follow_user.mapped_images.each do |mapped_image|
						expect(page).to have_content mapped_image.user.name
						expect(page).to have_content mapped_image.text
					end
				end
			end
		end
		feature "mypage_fav_mapped_image" do
			before do
				visit lincoln_riders_user_mypage_fav_mapped_images_path
			end
			scenario "表示内容の確認" do
				my_fav_mapped_images = @user1.fav_mapped_images
				my_fav_mapped_images.each do |mapped_image|
					expect(page).to have_content mapped_image.user.name
					expect(page).to have_content mapped_image.text
				end
			end
		end
		feature "show" do
			before do
				visit lincoln_riders_user_path(@user2)
			end
			scenario "表示内容の確認" do
				show_posts = @user2.posts.order(id: "DESC").limit(5)
				show_mapped_images = @user2.mapped_images.order(id: "DESC").limit(5)

				show_posts.each do |post|
					expect(page).to have_content post.user.name
					expect(page).to have_content post.text
				end
				show_mapped_images.each do |mapped_image|
					expect(page).to have_content mapped_image.user.name
					expect(page).to have_content mapped_image.text
				end
			end
		end
		feature "show_post" do
			before do
				visit lincoln_riders_user_show_posts_path(@user2)
			end
			scenario "表示内容の確認" do
				user_posts = @user2.posts
				user_posts.each do |post|
					expect(page).to have_content post.user.name
					expect(page).to have_content post.text
				end
			end
		end
		feature "show_fav_post" do
			before do
				visit lincoln_riders_user_show_fav_posts_path(@user2)
			end
			scenario "表示内容の確認" do
				user_fav_posts = @user2.fav_posts
				user_fav_posts.each do |post|
					expect(page).to have_content post.user.name
					expect(page).to have_content post.text
				end
			end
		end
		feature "show_mapped_image" do
			before do
				visit lincoln_riders_user_show_mapped_images_path(@user2)
			end
			scenario "表示内容の確認" do
				user_mapped_images = @user2.mapped_images
				user_mapped_images.each do |mapped_image|
					expect(page).to have_content mapped_image.user.name
					expect(page).to have_content mapped_image.text
				end
			end
		end
		feature "show_fav_mapped_image" do
			before do
				visit lincoln_riders_user_show_fav_mapped_images_path(@user1)
			end
			scenario "表示内容の確認" do
				user_fav_mapped_images = @user1.fav_mapped_images
				user_fav_mapped_images.each do |mapped_image|
					expect(page).to have_content mapped_image.user.name
					expect(page).to have_content mapped_image.text
				end
			end
		end
		feature "following_user_index" do
			before do
				visit following_users_index_lincoln_riders_user_path(@user1)
			end
			scenario "表示内容の確認" do
				@user1.following_users.each do |following_user|
					expect(page).to have_content following_user.name
				end
			end
		end
		feature "followed_user_index" do
			before do
				visit followed_users_index_lincoln_riders_user_path(@user1)
			end
			scenario "表示内容の確認" do
				@user1.followed_users.each do |followed_user|
						expect(page).to have_content followed_user.name
				end
			end
		end
		feature "edit" do
			before do
				visit edit_lincoln_riders_user_path(@user1)
			end
			scenario "表示内容の確認" do
				find_field("user_name").set("update_name_a")
				find_field("user_introduction").set("update_introduction_a")
				find("input[name='commit']").click
				expect(page).to have_content "update_name_a"
				expect(page).to have_content "update_introduction_a"
			end
		end
	end

end