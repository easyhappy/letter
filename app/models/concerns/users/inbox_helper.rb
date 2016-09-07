module Users
  module InboxHelper
    extend ActiveSupport::Concern

    def find_or_create_inbox friend
      inbox = Inbox.unscoped.find_or_create_by(user_id: self.id, friend_id: friend.id)
      inbox.undestroy

      inbox
    end
  end
end