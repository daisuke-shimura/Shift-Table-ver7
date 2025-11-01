class Admin::UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result
    if params[:keyword].present?
      keywords = params[:keyword].split(/[[:space:]・.,]+/)
      keywords.each do |kw|
        @users = @users.where(
          "CONCAT(users.last_name, users.middle_name, users.first_name) LIKE :kw
           OR users.last_name LIKE :kw
           OR users.middle_name LIKE :kw
           OR users.first_name LIKE :kw",
          kw: "%#{kw}%"
        )
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to admin_user_path(@user.id) }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_users_path, alert: "更新に失敗しました" }
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :middle_name, :last_name, :status, :created_at)
  end
end
