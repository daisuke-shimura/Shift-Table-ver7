class SwitchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reload_week_#{params[:week_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
