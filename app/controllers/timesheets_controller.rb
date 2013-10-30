class TimesheetsController < EmployeeBaseController
  authorize_resource :class => false
  
  def index
    @users = current_user.company.users.includes(:workdays)
                         .where("workdays.date >= ? AND workdays.date <= ? AND recurring_days = '{}'", Date.today.at_beginning_of_month, Date.today.at_end_of_month)
                         .references(:workdays)
  end

  def show
    @user = current_user.company.users.includes(:workdays)
                         .where("workdays.date >= ? AND workdays.date <= ? AND recurring_days = '{}'", Date.today.at_beginning_of_month, Date.today.at_end_of_month)
                         .references(:workdays).find(params[:id])
  end
end
