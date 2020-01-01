class CreateReplyRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :reply_relationships do |t|

		t.integer :replying_post_id
		t.integer :replied_post_id
		t.timestamps
    end
  end
end
