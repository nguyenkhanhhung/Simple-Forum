class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  validates :title, :content, :topic_id, :user_id, :presence => true
end
