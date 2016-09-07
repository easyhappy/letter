module ApplicationHelper
  def timeago time
    time.strftime("%y-%m-%d %H:%M")
  end
end
