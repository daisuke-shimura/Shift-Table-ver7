class Public::WeeksController < ApplicationController
  before_action :authenticate_user!
  def index
    @week = Week.new
    load_weeks
    load_calendar
    @user = current_user 

    @month = params[:month] ? Date.parse(params[:month]) : Date.today.beginning_of_month
  end

  def create
    @week = Week.new(week_params)
    if @week.save
      redirect_to weeks_path, notice: 'Week was successfully created.'
    else
      @weeks = Week.all
      load_weeks
      load_calendar
      @user = current_user 
      render :index, alert: 'Failed to create week.'
    end
  end

  def destroy
    @week = Week.find(params[:id])
    if @week.destroy
      redirect_to admin_weeks_path, notice: 'Week was successfully deleted.'
    else
      redirect_to admin_weeks_path, alert: 'Failed to delete week.'
    end
  end

  # def toggle_invisible
  #   @week = Week.find(params[:id])
  #   @week.update!(is_invisible: !@week.is_invisible)

  #   @users = User.all
  #   @jobs = Job.where(week_id: @week.id).group_by(&:user_id)
  #   @user = current_user

  #   respond_to do |format|
  #     format.turbo_stream { render }
  #     format.html { redirect_back fallback_location: week_jobs_path(@week.id) }
  #   end
  # end


  private

  def week_params
    params.require(:week).permit(:monday)
  end

  def load_weeks
    #@weeks = Week.all
    @today = Date.today
    after_tommorow = Date.today + 7
    @weeks = Week.order(monday: :asc).where("monday > ?", after_tommorow)
  end

  def load_calendar
    if @weeks.blank?
      # Weekデータがない場合のデフォルト動作
      today = Date.today
      @start_date = today.beginning_of_month
      @end_date   = today.end_of_month
      @calendar_rows = [] # 空配列にしておく
      return
    end

    earliest_date = @weeks.minimum(:monday)
    latest_date   = @weeks.maximum(:monday)
    @start_date = earliest_date.beginning_of_month
    @end_date = latest_date.end_of_month

    week_by_start = @start_date.cwday # 週番号（1:月曜, 7:日曜）
    week_by_end   = @end_date.cwday
    start_day = @start_date - (week_by_start - 1)
    end_day   = @end_date - (week_by_end - 1)

    days = start_day.step(end_day, 7).to_a
    week_mondays = @weeks.index_by { |week| week.monday.to_date }
    @calendar_rows = days.map { |date| [date, week_mondays[date]] }
  end
end
