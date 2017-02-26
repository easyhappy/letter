class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
