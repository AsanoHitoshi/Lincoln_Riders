class ReplyRelationship < ApplicationRecord
	belongs_to :replying_post, class_name: "Post"
	belongs_to :replied_post,  class_name: "Post"

end
