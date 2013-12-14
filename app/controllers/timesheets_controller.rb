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
      base_date = current_user.company.created_at.at_beginning_of_week + 4.days
      next_friday = Time.now.at_beginning_of_week + 4.days
      biweeks_past = ((next_friday - base_date)/2.weeks).floor + @offset
      @date_start = (base_date + (2*biweeks_past).weeks + 1.day).to_date
      @date_end = (base_date + (2*biweeks_past + 2).weeks).to_date
    when 'weekly' then
      base_date = (Date.today + 2.days).at_beginning_of_week - 2.days + @offset.weeks
      @date_start = base_date
      @date_end = base_date + 6.days
    end
  end
end
