class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  def index
    
  end

  def show 
    @user = current_user
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to weeks_path, notice: "ユーザを作成し、ログインしました"
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def myshift
    @user = current_user
  end

  def update
    user = current_user
    if user.update(user_params)
      redirect_to mypage_path, notice: "ユーザ情報を更新しました"
    else
      @user = user
      render :edit
    end
  end


  private
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :middle_name, :status,
      :time1, :time2, :time3, :time4, :time5, :time6, :time7
    )
  end
end
