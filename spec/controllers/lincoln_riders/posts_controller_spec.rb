require 'rails_helper'


RSpec.feature "posts_controllerに関する", type: :feature do
  before do
    @user1 = FactoryBot.create(:user, :create_with_posts)
    @user2 = FactoryBot.create(:user, :create_with_posts)
    @other_post = @user2.posts.first
    @my_post = @user1.posts.first
  end
  feature "ログインしていない状態で" do
    before do
      sign_out(@user1)
    end

    feature "以下のページへアクセスした際のリダイレクト先の確認" do
      scenario "postの一覧ページ" do
        visit lincoln_riders_posts_path
        expect(page).to have_current_path new_user_session_path
      end

      scenario "postの詳細ページ" do
        visit lincoln_riders_post_path(@my_post)
        expect(page).to have_current_path new_user_session_path
      end

      scenario "postの編集ページ" do
        visit edit_lincoln_riders_post_path(@my_post)
        expect(page).to have_current_path new_user_session_path
      end
    end
  end
  feature "ログインしている状態で" do
    before do
        login(@user1)
    end
    feature 'MypageからPostの作成機能について' do
      before do
        visit lincoln_riders_user_mypage_path
      end

      feature '正しい投稿をした時' do
        feature '表示内容が正しいか' do
          scenario 'textのみ投稿した時' do
            find_field('sidebar_text').set("create_text_a")
            find("input[name='sidebar_commit']").click
            expect(page).to have_content Post.last.text
            expect(page).to have_content Post.last.user.name
            expect(page).to have_content "Success"
          end
          scenario '画像込みの投稿した時' do
            find_field('sidebar_text').set("create_text_a")
            find('input[id="sidebar_post_image"]').set(File.dirname(__FILE__) + "/../../" +'files/sample.jpeg')
            find("input[name='sidebar_commit']").click
            expect(page).to have_content Post.last.text
            expect(page).to have_content Post.last.user.name
            expect(Post.find(Post.last.id).image_id).to be_truthy
            expect(page).to have_content "Success"
          end
        end
        scenario 'リダイレクト先が正しいか' do
            find_field('sidebar_text').set("create_text_a")
            find("input[name='sidebar_commit']").click
            expect(page).to have_current_path lincoln_riders_post_path(Post.last)
        end
        scenario '不正な投稿した時' do
          find_field('sidebar_text').set("")
          find("input[name='sidebar_commit']").click
        end
      end
    end
    feature 'Postの削除機能について' do
      before do
        visit lincoln_riders_post_path(@my_post)
      end

      scenario '自分の投稿を削除した時' do
        expect {
          find("a[id = 'post_deatroy']").click
        }.to change(@user1.posts, :count).by(-1)
      end
      scenario 'リダイレクト先が正しいか' do
        find("a[id = 'post_deatroy']").click
        expect(page).to have_current_path lincoln_riders_user_path(@user1.id)
      end
    end
    feature '投稿詳細ページのリンクと表示内容' do


        feature "自分の投稿詳細ページ表示" do
            scenario 'render先のページが詳細ページの表示内容の確認' do
                visit lincoln_riders_post_path(@my_post)
                expect(page).to have_content @my_post.text
                expect(page).to have_link "",href: edit_lincoln_riders_post_path(@my_post)
                expect(all("a[data-method='delete']")[-1][:href]).to eq(lincoln_riders_post_path(@my_post)) #削除ボタンがあることの確認
                expect(page).to have_content @user1.name
            end
        end
        feature "他人の投稿詳細ページ表示" do
          scenario 'render先のページが詳細ページの表示内容の確認' do
            visit lincoln_riders_post_path(@other_post)
            expect(page).to have_content @other_post.text
            expect(page).to_not have_link "",href: edit_lincoln_riders_post_path(@other_post)
            expect(all("a[data-method='delete']")[-1][:href]).to_not eq(lincoln_riders_post_path(@other_post)) #削除ボタンがあることの確認
            expect(page).to have_content @user2.name
          end
        end
    end
    feature '投稿一覧ページについて' do
      scenario "postの一覧ページの表示内容とリンクは正しいか" do
        visit lincoln_riders_posts_path
        posts = Post.all
        posts.each do |post|
          expect(page).to have_content post.text
          expect(page).to have_content post.user.name
        end
      end
    end
    feature '投稿編集ページについて' do
      scenario '他人のPostの編集ページへアクセスした時' do
        visit edit_lincoln_riders_post_path(@other_post)
        expect(page).to have_current_path lincoln_riders_post_path(@other_post.id)
      end
      feature '自分のPostの編集ページへアクセスした時' do
        before do
          visit edit_lincoln_riders_post_path(@my_post)
        end
        feature '正しい投稿をした時' do
          before do
            find_field('post_text').set("update_text_a")
            find("input[name='commit']").click
          end

          scenario "bookが更新されているか" do
            expect(page).to have_content "update_text_a"
          end
          scenario "リダイレクト先は正しいか" do
            expect(page).to have_current_path lincoln_riders_post_path(@my_post)
          end
          scenario 'サクセスメッセージが出るか' do
            expect(page).to have_content "Success"
          end
        end
        feature '不正な投稿をした時' do
          before do
            text = @my_post.text
            find_field('post_text').set("")
            find("input[name='commit']").click
          end
          scenario "bookが更新されていないか" do
            expect(page).to have_content text
          end
          scenario "リダイレクト先は正しいか" do
            expect(page).to have_current_path edit_lincoln_riders_post_path(@my_post)
          end
          scenario 'エラーメッセージが出るか' do
            expect(page).to have_content "Error"
          end
        end
      end
    end
  end
end
