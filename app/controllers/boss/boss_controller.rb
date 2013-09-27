class Boss::BossController < ::EmployeeController
  before_filter :can_admin?
  
  protected
  
  def can_admin?
    # check and see if current_user is an organization admin
  end
end
