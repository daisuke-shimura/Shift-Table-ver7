class SwitchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reload_weeks"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
