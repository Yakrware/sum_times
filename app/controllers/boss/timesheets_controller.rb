class Boss::TimesheetsController < Boss::BossController
  respond_to :html
  def index
    month = params[:month].to_i unless params[:month].blank?
    year = params[:year].to_i unless params[:year].blank?
    @date = Date.today.at_beginning_of_month.change(:month => month, :year => year )
    @timesheets = Timesheet.where(month: @date.month, year: @date.year)
    respond_with(@timesheets, @date)
  end

  def show
    @timesheet = Timesheet.find(params[:id])

    respond_with(@timesheet)
  end

  def generate
    month = params[:month].blank? ? params[:month] : Date.today.month
    year = params[:year].blank? ? params[:year] : Date.today.year
    Timesheet.generate_all_timesheets(month, year)

    redirect_to admin_timesheets_path(month: params[:month], year: params[:year])
  end
end
