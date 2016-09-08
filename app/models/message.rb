class Message < ApplicationRecord
  include Common::SoftDelete
  include Common::TimeHandler
  belongs_to   :user
  belongs_to   :friend, class_name: "User"
  belongs_to   :inbox
  belongs_to   :friend_inbox, class_name: "Inbox"
  after_create :update_inbox
  after_create :notify_inbox_of_friend

  validates    :content, presence: {message: I18n.t("messages.content_should_not_empty")}

  scope :inbox_messages, -> (inbox){where("inbox_id = ? or friend_inbox_id = ?", inbox.id, inbox.id).order("created_at desc")}

  private
  def update_inbox
    self.inbox.touch
    self.friend_inbox.increment!(:unread_count, 1)
  end

  def notify_inbox_of_friend
    options = {
      inbox: { 
                id: self.friend_inbox.id,            unread_count: self.friend_inbox.unread_count,
                friend_username: self.user.username, created_at:   self.timeago(self.friend_inbox.updated_at)
              },
      message: {
                 id: self.id, content: self.content, username: self.user.username,
                 friend_username: self.friend.username, created_at: self.timeago(self.created_at)
               }
    }

    ActionCable.server.broadcast "letter_notifications_#{self.friend.id}", options 
  end
end
