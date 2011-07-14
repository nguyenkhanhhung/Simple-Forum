class Topic < ActiveRecord::Base
  has_many :replies
  has_one :user
  belongs_to :forum
  validates :title, :forum_id, :user_id, :view, :content, :presence => true
end
