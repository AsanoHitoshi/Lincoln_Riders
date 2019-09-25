require 'rails_helper'


RSpec.feature "mapped_images_controllerに関する", type: :feature do
	before do
		@user1 = FactoryBot.create(:user, :create_with_mapped_images)
		@user2 = FactoryBot.create(:user, :create_with_mapped_images)
		@my_mapped_image = @user1.mapped_images.first
		@other_mapped_image = @user2.mapped_images.first

	end
	feature "ログインしていない時に" do
		before do
			sign_out(@user1)
		end
		feature "以下のページへアクセスした際のリダイレクト先の確認" do
			scenario "MappedImages作成ページ" do
				visit new_lincoln_riders_mapped_image_path
				expect(page).to have_current_path new_user_session_path
			end
			scenario "MappedImages一覧ページ" do
				visit lincoln_riders_mapped_images_path
				expect(page).to have_current_path new_user_session_path
			end
			scenario "MappedImages詳細ページ" do
				visit lincoln_riders_mapped_image_path(@my_mapped_image)
				expect(page).to have_current_path new_user_session_path
			end
			scenario "MappedImages編集ページ" do
				visit edit_lincoln_riders_mapped_image_path(@my_mapped_image)
				expect(page).to have_current_path new_user_session_path
			end
		end
	end
	feature "ログインしてる時に" do
		before do
			login(@user1)
		end
		feature "MappedImages作成ページ" do
			before do
				visit new_lincoln_riders_mapped_image_path
			end
			feature "正しい入力内容のとき" do
				before do
					find_field("mapped_image_text").set("create_text_a")
					find('input[id="mapped_image_image"]').set(File.dirname(__FILE__) + "/../../" +'files/sample.jpeg')
					find_field("mapped_image_position_lat").set("0")
					find_field("mapped_image_position_lng").set("0")
				end
				scenario "保存されて、リダイレクト先で表示されているか" do
					expect {
						find("input[id='mapped_image_create_submit']").click
					}.to change(@user1.mapped_images, :count).by(1)
					expect(page).to have_content @user1.mapped_images.last.text
				end
			end
			feature "間違えた内容のとき" do
				scenario "textが空欄のとき" do
					# 間違った入力
					find_field("mapped_image_text").set("")

					# 正しい入力
					find('input[id="mapped_image_image"]').set(File.dirname(__FILE__) + "/../../" +'files/sample.jpeg')
					find_field("mapped_image_position_lat").set("0")
					find_field("mapped_image_position_lng").set("0")

					expect {
						find("input[id='mapped_image_create_submit']").click
					}.to change(@user1.mapped_images, :count).by(0)
					expect(page).to have_content "Error"
				end
				scenario "imageがアップロードされていない場合" do
					# 間違った入力
					# find('input[id="mapped_image_image"]').set(File.dirname(__FILE__) + "/../../" +'files/sample.jpeg')

					# 正しい入力
					find_field("mapped_image_text").set("create_text_a")
					find_field("mapped_image_position_lat").set("0")
					find_field("mapped_image_position_lng").set("0")
					expect {
						find("input[id='mapped_image_create_submit']").click
					}.to change(@user1.mapped_images, :count).by(0)
					expect(page).to have_content "Error"
				end
				scenario "mapped_image_position_latが空欄のとき" do
					# 間違った入力
					find_field("mapped_image_position_lat").set("")

					# 正しい入力
					find_field("mapped_image_text").set("create_text_a")
					find('input[id="mapped_image_image"]').set(File.dirname(__FILE__) + "/../../" +'files/sample.jpeg')
					find_field("mapped_image_position_lng").set("0")
					expect {
						find("input[id='mapped_image_create_submit']").click
					}.to change(@user1.mapped_images, :count).by(0)
					expect(page).to have_content "Error"
				end
				scenario "mapped_image_position_lngが空欄のとき" do
					# 間違った入力
					find_field("mapped_image_position_lng").set("")

					# 正しい入力
					find_field("mapped_image_text").set("create_text_a")
					find('input[id="mapped_image_image"]').set(File.dirname(__FILE__) + "/../../" +'files/sample.jpeg')
					find_field("mapped_image_position_lat").set("0")
					expect {
						find("input[id='mapped_image_create_submit']").click
					}.to change(@user1.mapped_images, :count).by(0)
					expect(page).to have_content "Error"
				end
			end

		end
		feature "MappedImages一覧ページ" do
			before do
				visit lincoln_riders_mapped_images_path
			end
			scenario "表示内容の確認" do
				mapped_images = MappedImage.all
				mapped_images.each do |mapped_image|
					expect(page).to have_content mapped_image.text
					expect(page).to have_content mapped_image.user.name
					expect(page).to have_selector "img[src='#{Refile.attachment_url(mapped_image, :image)}']"
				end
			end
		end
		feature "MappedImages詳細ページ" do
			before do
				visit lincoln_riders_mapped_image_path(@my_mapped_image)
			end
			scenario "表示内容の確認" do
				expect(page).to have_content @my_mapped_image.text
				expect(page).to have_content @my_mapped_image.user.name
				expect(page).to have_selector "img[src='#{Refile.attachment_url(@my_mapped_image, :image)}']"
			end
		end

		feature "MappedImages編集ページ" do
			feature "作成者以外のユーザーがアクセスした場合" do
				before do
					visit edit_lincoln_riders_mapped_image_path(@other_mapped_image)
				end
					scenario "保存されて、リダイレクト先で表示されているか" do
						expect(page).to have_current_path lincoln_riders_mapped_image_path(@other_mapped_image)
					end
			end
			feature "作成者がアクセスした場合" do
				feature "正しい入力内容のとき" do
					before do
						visit edit_lincoln_riders_mapped_image_path(@my_mapped_image)
						find_field("mapped_image_text").set("update_text_a")
						find('input[id="mapped_image_image"]').set(File.dirname(__FILE__) + "/../../" +'files/sample.jpeg')
						find_field("mapped_image_position_lat").set("1")
						find_field("mapped_image_position_lng").set("1")
					end
					scenario "保存されて、リダイレクト先で表示されているか" do
						expect {
							find("input[id='update_mapped_image_submit']").click
						}.to change(@user1.mapped_images, :count).by(0)
						expect(page).to have_content "update_text_a"
					end
				end
			end
		end
	end
end