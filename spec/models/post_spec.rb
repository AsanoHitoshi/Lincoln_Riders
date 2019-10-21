require 'rails_helper'

RSpec.describe Post, type: :model do
	context "正しい値を代入した時に保存できるかどうか" do
		before do
			@user1 = User.create!(
				:email => "test@test",
				:password => "hogehoge",
				:password_confirmation => "hogehoge"
			)
		end
		it "orders them in reverse chronologically" do
			post = Post.create!(
				:text => "text1",
				:user_id => @user1.id
			)
			expect(@user1.posts).to eq([post])
		end
	end
end
