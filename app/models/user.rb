class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def avatar_url
    if avatar.present?
      return avatar
    else
      "/assets/default_avatar.jpg"
    end
  end
end
