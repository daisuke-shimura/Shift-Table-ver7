class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  def index
    
  end

  def show 
    
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
    
  end

  def update
    
  end


  private
  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
