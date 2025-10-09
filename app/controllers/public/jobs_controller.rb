class Public::JobsController < ApplicationController
  def index
    @week = Week.find(params[:week_id])
    #@users = User.all
    @users = User.includes(:jobs).where(jobs: { week_id: @week.id })
    @user = current_user
    @job = Job.new
  end

  def create
    job = Job.new(job_params)
    week = Week.find(params[:week_id])
    job.week_id = week.id
    job.user_id = current_user.id
    job.save
    redirect_to request.referer
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    
  end

  private
  def job_params
    params.require(:job).permit(:time1, :time2, :time3, :time4, :time5, :time6, :time7, :comment)
  end
end
