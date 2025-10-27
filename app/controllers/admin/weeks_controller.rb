class Admin::WeeksController < ApplicationController
  def index
    @week = Week.new
    load_weeks
    load_calendar
    @admin = current_admin
    @setting = Setting.instance
    @date = @today.beginning_of_week(:monday) + 21
    if (!Time.zone.today.monday? || Time.zone.now.hour >= 9) && !@weeks.exists?(monday: @date)
      puts "＝＝＝＝＝＝＝＝＝＝自動作成: #{@date}＝＝＝＝＝＝＝＝＝＝"
      Week.create(monday: @date)
      Week.find_by(monday: @date - 14)&.update(is_created: true)
      puts "＝＝＝＝＝＝＝＝＝＝#{@date - 14}＝＝＝＝＝＝＝＝＝＝"
    end
  end

  def create
    @week = Week.new(week_params)
    if @week.save
      redirect_to admin_weeks_path, notice: "#{(@week.monday).month}月#{(@week.monday).day}日～#{(@week.sunday).month}月#{(@week.sunday).day}日の週を作成しました。"
    else
      @weeks = Week.all
      load_weeks
      load_calendar
      @admin = current_admin
      @setting = Setting.instance
      respond_to do |format|
        format.html { render :index, status: :unprocessable_entity }
        format.turbo_stream { render 'create_failed', status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @week = Week.find(params[:id])
    if @week.destroy
      redirect_to admin_weeks_path, notice: "#{(@week.monday).month}月#{(@week.monday).day}日～#{(@week.sunday).month}月#{(@week.sunday).day}日の週を削除しました。"
    else
      redirect_to admin_week_job_path(@week.id), alert: 'Failed to delete week.'
    end
  end

  def past
    past_load_weeks
    past_load_calendar
    @admin = current_admin
  end

  def is_created
    @week = Week.find(params[:id])
    @week.update!(is_created: !@week.is_created)
    # redirect_to  admin_week_jobs_past_path(@week.id)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to request.referer }
    end
  end


  private

  def week_params
    params.require(:week).permit(:monday)
  end

  def load_weeks
    #@weeks = Week.all
    @today = Date.today
    after_tommorow = Date.today + 7
    @weeks = Week.order(monday: :asc).where("monday > ?", after_tommorow).where(is_created: false)
  end

  def past_load_weeks
    @today = Date.today
    after_tommorow = Date.today + 7
    @weeks = Week.order(monday: :asc).where("monday <= ?", after_tommorow).or(Week.where(is_created: true))
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

    @earliest_date = @weeks.minimum(:monday)
    latest_date   = @weeks.maximum(:monday)
    # @start_month = earliest_date.beginning_of_month
    @start_date = @today.beginning_of_month
    @end_date = latest_date.end_of_month
    # @past_start_date = latest_date.beginning_of_month

    week_by_start = @start_date.cwday # 週番号（1:月曜, 7:日曜）
    week_by_end   = @end_date.cwday
    start_day = @start_date - (week_by_start - 1)
    end_day   = @end_date - (week_by_end - 1)

    days = start_day.step(end_day, 7).to_a
    week_mondays = @weeks.index_by { |week| week.monday.to_date }
    @calendar_rows = days.map { |date| [date, week_mondays[date]] }
  end

  def past_load_calendar
    if @weeks.blank?
      # Weekデータがない場合のデフォルト動作
      today = Date.today
      @start_date = today.beginning_of_month
      @end_date   = today.end_of_month
      @calendar_rows = [] # 空配列にしておく
      return
    end

    earliest_date = @weeks.minimum(:monday)
    # latest_date   = @weeks.maximum(:monday)
    @start_date = earliest_date.beginning_of_month
    # @end_date = latest_date.end_of_month
    @end_date = @weeks.maximum(:monday)
    @past_start_date = @end_date.beginning_of_month

    week_by_start = @start_date.cwday # 週番号（1:月曜, 7:日曜）
    week_by_end   = @end_date.cwday
    start_day = @start_date - (week_by_start - 1)
    end_day   = @end_date - (week_by_end - 1)

    days = start_day.step(end_day, 7).to_a
    week_mondays = @weeks.index_by { |week| week.monday.to_date }
    @calendar_rows = days.map { |date| [date, week_mondays[date]] }
  end
end
