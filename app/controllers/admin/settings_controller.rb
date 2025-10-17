class Admin::SettingsController < ApplicationController
  def toggle_visible
    @setting = Setting.instance
    @setting.update!(is_visible: !@setting.is_visible)
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to admin_settings_path, notice: "表示状態を変更しました" }
    end

    ActionCable.server.broadcast("reload_all", { action: "reload" })
  end
end
