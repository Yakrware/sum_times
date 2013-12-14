class PunchClockController < EmployeeBaseController
  before_filter :get_workday
  
  def in
    @workday.close_pairs params[:time]
    @workday.open_pair params[:time]
    respond_to do |format|
      if @workday.save
        format.json { render 'workdays/on_date' }
        format.any { redirect_to :back }
      else
        format.json { render :json => {errors: @workday.errors.full_messages} }
        format.any { redirect_to :back, errors: @workday.errors.full_messages }
      end
    end
  end
  
  def out
    # close any open pairs in workday     
    @workday.close_pairs params[:time]
    respond_to do |format|
      if @workday.save
        format.json { render 'workdays/on_date' }
        format.any { redirect_to :back }
      else
        format.json { render :json => {errors: @workday.errors.full_messages} }
        format.any { redirect_to :back, errors: @workday.errors.full_messages }
      end
    end
  end
  
  protected
  def get_workday
    @workday = current_user.workdays.on_date(params[:date]).first
    if @workday.nil?
      @workday = current_user.workdays.build date: params[:date], hours: [] 
    else
      @workday = Workday.find(@workday.id) # defeat read-only record
    end
  end
end
