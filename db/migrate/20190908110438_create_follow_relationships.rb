class CreateFollowRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_relationships do |t|
      t.integer :following_user_id
      t.integer :followed_user_id

      t.timestamps
    end
  end
end
