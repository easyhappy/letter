class Inbox < ApplicationRecord
  include Common::SoftDelete
  belongs_to :user
  belongs_to :friend, class_name: "User"
end
