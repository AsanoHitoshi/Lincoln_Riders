require 'rails_helper'

RSpec.describe ReplyRelationship, type: :model do
	pending "add some examples to (or delete) #{__FILE__}"
	context "About ReplyRelationship create" do
		before do
		    @user1 = FactoryBot.create(:user, :create_with_posts)
    		@user2 = FactoryBot.create(:user, :create_with_posts)
		end
		it "保存可能かどうか" do
			# comment1 = post.comments.create!(:body => "first comment")
			# comment2 = post.comments.create!(:body => "second comment")
			# expect(post.reload.comments).to eq([comment2, comment1])
		end
	end
end
