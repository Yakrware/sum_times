class EmployeeBaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_current_workday
  
  layout 'employee'
  
  protected
  def get_current_workday
    workday = current_user.workdays.today.first
    @current_workday = (workday.nil? || workday.recurring?) ? nil : Workday.find(workday.id)
  end
end
