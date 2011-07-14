class AddContentToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :content, :string
  end

  def self.down
    remove_column :topics, :content
  end
end
