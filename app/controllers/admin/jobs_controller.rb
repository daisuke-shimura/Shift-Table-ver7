class Admin::JobsController < ApplicationController
  def index
    @week = Week.find(params[:week_id])
    @users = User.all
    @jobs = Job.where(week_id: @week.id).group_by(&:user_id)
    @setting = Setting.instance
  end

  def print
    @week = Week.find(params[:week_id])
    @users = User.joins(:jobs).where(jobs: { week_id: @week.id }).order('users.id ASC')
    # @users = User.where(jobs: { week_id: @week.id })
    # @users = User.all
    @jobs = Job.where(week_id: @week.id).group_by(&:user_id)
    
    render layout: "print"
  end

  def past
    @week = Week.find(params[:week_id])
    @users = User.all
    @jobs = Job.where(week_id: @week.id).group_by(&:user_id)
  end
  
end
