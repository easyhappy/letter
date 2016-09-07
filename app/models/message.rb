class Message < ApplicationRecord
  include Common::SoftDelete
  belongs_to :user
  belongs_to :friend, class_name: "User"

  scope :inbox_messages, -> (inbox){where("inbox_id = ? or friend_inbox_id = ?", inbox.id, inbox.id).order("created_at desc")}
end
