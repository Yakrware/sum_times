class PunchClockController < EmployeeBaseController
  def in
    # close any open pairs in workday, open new pair
    if @current_workday.nil?
      # create workday
      @current_workday = current_user.workdays.build date: Date.today, hours: []
    end
    
    @current_workday.close_pairs
    @current_workday.open_pair
    respond_to do |format|
      if @current_workday.save
        format.any { redirect_to :back }
      else
        format.any { redirect_to :back, errors: @current_workday.errors.full_messages }
      end
    end
  end
  
  def out
    # close any open paris in workday     
    @current_workday.close_pairs
    respond_to do |format|
      if @current_workday.save
        format.any { redirect_to :back }
      else
        format.any { redirect_to :back, errors: @current_workday.errors.full_messages }
      end
    end
  end
end
