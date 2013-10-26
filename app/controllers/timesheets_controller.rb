class TimesheetsController < EmployeeBaseController
  respond_to :html

  def index
    @timesheets = current_user.timesheets_to_accept.waiting_for_supervisor
    respond_with(@timesheets)
  end

  def current
    unless current_user.timesheets.waiting_for_user.empty?
      redirect_to timesheet_path(current_user.timesheets.waiting_for_user.first.id)
    else
      timesheet = current_user.timesheets.where(month: Date.today.month, year: Date.today.year).first_or_initialize
      unless timesheet.persisted?
        timesheet.generate_schedule
        timesheet.save
      end
      redirect_to timesheet_path(timesheet)
    end
  end

  def show
    @timesheet = current_user.timesheets.where(id: params[:id]).first
    unless @timesheet
      @timesheet = current_user.timesheets_to_accept.where(id: params[:id]).first
      @is_supervisor = @timesheet.present?
    end

    respond_with(@timesheet, @is_supervisor)
  end

  def update
    # user can update the timesheet to change the hours worked. recalculate the total hours worked and the total hours server side
    @timesheet = current_user.timesheets.where(id: params[:id]).first

    schedule = @timesheet.schedule

    params[:schedule].each do |date, v|
      dif = v.to_f - schedule[date]["worked_hours"]
      schedule[date]["worked_hours"] = v.to_f
      @timesheet.worked_hours += dif
      @timesheet.total_hours += dif
    end

    @timesheet.schedule = schedule
    @timesheet.save

    respond_with(@timesheet) do |format|
      format.any { render :nothing => true}
    end
  end

  def submit
    @timesheet = current_user.timesheets.find(params[:id])
    @timesheet.update_attributes user_approved: true

    if @timesheet.user.supervisors.blank? # shortcut supervisor approval if user has no supervisors
      @timesheet.update_attributes supervisor_approved: true
    else
      TimesheetMailer.submitted(@timesheet).deliver
    end

    redirect_to timesheet_path(@timesheet)
  end

  def accept
    @timesheet = current_user.timesheets_to_accept.find(params[:id])
    @timesheet.update_attributes supervisor_approved: true

    redirect_to timesheet_path(@timesheet)
  end

  def reject
    @timesheet = current_user.timesheets_to_accept.find(params[:id])
    @timesheet.update_attributes user_approved: nil

    TimesheetMailer.rejected(@timesheet, current_user).deliver

    redirect_to timesheet_path(@timesheet)
  end

  def regenerate
    @timesheet = current_user.timesheets.find(params[:id])

    if @timesheet
      @timesheet.generate_schedule
      @timesheet.save
    end

    redirect_to timesheet_path(@timesheet)
  end
end
