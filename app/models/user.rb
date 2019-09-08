class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
 	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

	has_many :active_follow_relationships, 	class_name: "FollowRelationship", foreign_key: :following_user_id
	has_many :following_users, through: :active_follow_relationships, source: :followed_user

	has_many :passive_follow_relationships, class_name: "FollowRelationship", foreign_key: :followed_user_id
	has_many :followed_users, through: :passive_follow_relationships, source: :following_user


	has_many :posts
	has_many :mapped_images

  def followed_by?(user)
    passive_follow_relationships.find_by(following_user_id: user.id).present?
  end
end
