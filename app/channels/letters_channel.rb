class LettersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "letter_notifications_#{current_user.id}"
  end

  def unsubscribed
  end

end
