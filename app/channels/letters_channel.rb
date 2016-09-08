class LettersChannel < ApplicationCable::Channel
  def subscribed
    puts "------------"
    puts "letter_notifications_#{current_user.id}"
    stream_from "letter_notifications_#{current_user.id}"
  end

  def unsubscribed
  end

end
