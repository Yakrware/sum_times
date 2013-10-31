class SchedulesController < EmployeeBaseController
  authorize_resource :class => false

  def index
    @users = current_user.company.users.includes(:option).reject{|u| !u.option.scheduled?}
  end

  def create
  end
  
  def update
  end
  
  def delete
  end
end
