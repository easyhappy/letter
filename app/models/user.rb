class User < ApplicationRecord
  include Users::MessageHelper
  include Users::InboxHelper

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :inboxes

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
