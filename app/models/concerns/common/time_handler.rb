module Common
  module TimeHandler
    extend ActiveSupport::Concern

    def timeago time
      time.in_time_zone("Beijing").strftime("%y-%m-%d %H:%M")
    end
  end
end