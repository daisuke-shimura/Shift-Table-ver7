# app/controllers/public/user_sessions_controller.rb
class Public:: UserSessionsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  def new
    @users = User.all
  end

  def create
    user = User.find(params[:user_id])
    if user
      session[:user_id] = user.id
      redirect_to weeks_path, notice: "ログインしました"
    else
      redirect_to login_path, alert: "ユーザーが見つかりません"
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "ログアウトしました"
  end
end
