class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.string :title
      t.string :content
      t.integer :topic_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
