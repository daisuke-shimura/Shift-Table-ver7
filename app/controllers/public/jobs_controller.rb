class Public::JobsController < ApplicationController
  def index
    @week = Week.find(params[:week_id])
    @users = User.all
    @jobs = Job.where(week_id: @week.id).group_by(&:user_id)
    @user = current_user
    @job = Job.new
  end

  def create
    job = Job.new(job_params)
    @week = Week.find(params[:week_id])
    job.week_id = @week.id
    job.user_id = current_user.id
    if job.save
      @users = User.all
      @jobs  = Job.where(week_id: @week.id).group_by(&:user_id)
      @user  = current_user
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to request.referer }
      end
    else
      format.html { redirect_to request.referer, alert: "Failed to create job." }
    end
  end

  def edit
    @week = Week.find(params[:week_id])
    @users = User.all
    @jobs = Job.where(week_id: @week.id).group_by(&:user_id)
    @user = current_user
    @job = Job.find(params[:id])
  end

  def update
    job = Job.find(params[:id])
    @week = Week.find(params[:week_id])
    if job.update(job_params)
      @users = User.all
      @jobs  = Job.where(week_id: @week.id).group_by(&:user_id)
      @user  = current_user
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to week_jobs_path(@job.week_id) }
      end
    else
      format.html { redirect_to week_jobs_path(@job.week_id), alert: "Failed to create job." }
    end
  end

  def destroy
    job = Job.find(params[:id])
    @week = Week.find(params[:week_id])
    if job.destroy
      @users = User.all
      @jobs  = Job.where(week_id: @week.id).group_by(&:user_id)
      @user  = current_user
      @job = Job.new
      respond_to do |format|
        format.turbo_stream { render }
        format.html { redirect_to request.referer }
      end
    else
      format.html { redirect_to request.referer, alert: "Failed to create job." }
    end
  end

  private
  def job_params
    params.require(:job).permit(:time1, :time2, :time3, :time4, :time5, :time6, :time7, :comment)
  end
end
