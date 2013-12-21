class TimesheetsController < EmployeeBaseController
  authorize_resource :class => false
  before_filter :set_dates
  
  def index
    @users = current_user.company.users.includes(:workdays)
                         .where("workdays.date >= ? AND workdays.date <= ? AND recurring_days = '{}'", @date_start, @date_end)
                         .references(:workdays)
  end

  def show
    @user = current_user.company.users.includes(:workdays)
                         .where("workdays.date >= ? AND workdays.date <= ? AND recurring_days = '{}'", @date_start, @date_end)
                         .references(:workdays).find(params[:id])
  end
  
  protected
  def set_dates
    @offset = params[:offset].present? ? params[:offset].to_i : -1
    case current_user.option.pay_period
    when 'monthly' then
      base_date = Date.today + @offset.months
      @date_start = base_date.at_beginning_of_month
      @date_end = base_date.at_end_of_month
    when 'bi-monthly' then
      if (Date.today.day > 15 && @offset.odd?) || (Date.today.day < 15 && @offset.even?)
        base_date = Date.today + (@offset/2).floor.months
        @date_start = base_date.at_beginning_of_month
        @date_end = base_date.change(:day => 15)
      else
        base_date = Date.today + (@offset/2).floor.months
        @date_start = base_date.dup.change(:day => 16)
        @date_end = base_date.at_end_of_month
      end
    when 'bi-weekly' then
      bi_weekly(4)
    when 'bi-weekly-thursday' then
      bi_weekly(3)
    when 'bi-weekly-sunday' then
      bi_weekly(6)
    when 'weekly' then
      weekly(2)
    when 'weekly-thursday' then
      weekly(3)
    when 'weekly-sunday' then
      weekly(0)
    end
  end
  
  def bi_weekly(day_offset)
    base_date = current_user.company.created_at.at_beginning_of_week + day_offset.days
    next_friday = Time.now.at_beginning_of_week + day_offset.days
    biweeks_past = ((next_friday - base_date)/2.weeks).floor + @offset
    @date_start = (base_date + (2*biweeks_past).weeks + 1.day).to_date
    @date_end = (base_date + (2*biweeks_past + 2).weeks).to_date
  end
  
  def weekly(week_start_offset)
    base_date = (Date.today + week_start_offset.days).at_beginning_of_week - week_start_offset.days + @offset.weeks
    @date_start = base_date
    @date_end = base_date + 6.days
  end
end
