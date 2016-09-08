class Message < ApplicationRecord
  include Common::SoftDelete
  belongs_to :user
  belongs_to :friend, class_name: "User"
  belongs_to :inbox
  belongs_to :friend_inbox, class_name: "Inbox"
  after_create :update_inbox

  scope :inbox_messages, -> (inbox){where("inbox_id = ? or friend_inbox_id = ?", inbox.id, inbox.id).order("created_at desc")}

  private
  def update_inbox
    self.inbox.touch
    self.friend_inbox.increment!(:unread_count, 1)
  end
end
