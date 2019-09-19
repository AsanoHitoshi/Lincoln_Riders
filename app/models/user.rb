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
	has_many :post_favs
	has_many :fav_posts, through: :post_favs, source: :post
	has_many :mapped_images_favs
	has_many :fav_mapped_images, through: :mapped_images_favs, source: :mapped_image


	attachment :profile_image


  def followed_by?(user)
    passive_follow_relationships.find_by(following_user_id: user.id).present?
  end

end
