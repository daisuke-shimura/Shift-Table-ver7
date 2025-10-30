class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to admin_users_path, notice: "ステータスを更新しました" }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_users_path, alert: "更新に失敗しました" }
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :status)
  end
end
