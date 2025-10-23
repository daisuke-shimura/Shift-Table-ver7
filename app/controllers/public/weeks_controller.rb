class Public::WeeksController < ApplicationController
  before_action :authenticate_user!
  def index
    @week = Week.new
    load_weeks
    load_calendar
    @user = current_user 
    @date = @today.beginning_of_week(:monday) + 21
    if (!Time.zone.today.monday? || Time.zone.now.hour >= 9) && !@weeks.exists?(monday: @date)
      puts "＝＝＝＝＝＝＝＝＝＝自動作成: #{@date}＝＝＝＝＝＝＝＝＝＝"
      Week.create(monday: @date)
      Week.find_by(monday: (@date-21))&.update(is_created: true)
    end
  end

  def past
    past_load_weeks
    past_load_calendar
    @user = current_user
  end


  private

  def load_weeks
    #@weeks = Week.all
    @today = Date.today
    after_tommorow = Date.today + 7
    @weeks = Week.order(monday: :asc).where("monday > ?", after_tommorow)
  end

  def past_load_weeks
    @today = Date.today
    after_tommorow = Date.today + 7
    @weeks = Week.order(monday: :asc).where("monday <= ?", after_tommorow)
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
    # @start_date = earliest_date.beginning_of_month
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
    latest_date   = @weeks.maximum(:monday)
    @start_date = earliest_date.beginning_of_month
    @end_date = latest_date.end_of_month
    @past_start_date = latest_date.beginning_of_month

    week_by_start = @start_date.cwday # 週番号（1:月曜, 7:日曜）
    week_by_end   = @end_date.cwday
    start_day = @start_date - (week_by_start - 1)
    end_day   = @end_date - (week_by_end - 1)

    days = start_day.step(end_day, 7).to_a
    week_mondays = @weeks.index_by { |week| week.monday.to_date }
    @calendar_rows = days.map { |date| [date, week_mondays[date]] }
  end
end
