module ApplicationHelper
  def timeago time
    return unless time
    time.strftime("%y-%m-%d %H:%M")
  end
end
