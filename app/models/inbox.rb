class Inbox < ApplicationRecord
  include Common::SoftDelete
  belongs_to :user
  belongs_to :friend, class_name: "User"
  has_many  :messages

  def reset_unread_count
    self.update_columns(:unread_count => 0)
  end
end
