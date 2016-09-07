module Users
  module MessageHelper
    extend ActiveSupport::Concern

    def send_message friend, content
      unless friend
        return [false, I18n.t("common.user_not_exist")]
      end

      if self.id == friend.id
        return [false, I18n.t("inboxes.cannot_send_message_to_self")]
      end

      if content.blank?
        return [false, I18n.t("inboxes.content_should_not_empty")]
      end

      self_inbox   = self.find_or_create_inbox friend
      friend_inbox = friend.find_or_create_inbox self

      message = Message.create(user_id: self.id, friend_id: friend.id,
                               inbox_id: self_inbox.id, friend_inbox_id: friend_inbox.id, content: content)

      if message.errors.present?
        return [false, message.errors.messages.values.flatten.join("\n")]
      end

      return [true, message]
    end
  end
end