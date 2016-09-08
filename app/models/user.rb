class User < ApplicationRecord
  include Users::MessageHelper
  include Users::InboxHelper

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :inboxes, -> { order("updated_at desc")}
  has_many :messages
  has_many :friends, through: :inboxes

  scope :users_without_me, -> (user) { where.not(:id => [user.id]).order("created_at desc") }

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
