class SchedulesController < EmployeeBaseController
  authorize_resource :class => false

  def index
    @date = (params[:date] || Date.today).to_date
    @users = current_user.company.users.includes(:option).reject{|u| !u.option.scheduled?}
  end

  def create
    # see if there is a workday that is overriding the scheduling
    @workday = Workday.where(user_id: params[:user_id]).on_date(params[:date]).first
    if @workday && @workday.recurring_days.blank?
      # delete overriding workday
      @workday.delete
      @workday = Workday.where(user_id: params[:user_id]).on_date(params[:date]).first
    else
      # create a blank workday (and give it some hours)
      @user = User.find(params[:user_id])
      @workday = @user.workdays.create(date: params[:date])
      @workday.set_hours params[:hours].map{|a| a[1]} || [[@user.option.day_start, @user.option.day_end, 'scheduled']]
      @workday.save
    end
  end
  
  def update
    @workday = Workday.find(params[:id])
    # see if the workday is an actual workday or recurring
    unless @workday.recurring_days.blank?
      # create a new workday
      @workday = @workday.user.workdays.create(date: params[:date])
    end
    # update hours
    byebug
    @workday.set_hours params[:hours].map{|a| a[1]}
    @workday.save
  end
  
  def destroy
    @workday = Workday.find(params[:id])
    # see if the workday is recurring
    unless @workday.recurring_days.blank?
      # write a blank worday the workday
      @workday = @workday.user.workdays.create(date: params[:date], hours: [])
    else
      # delete the workday
      @workday.delete
    end
    
    respond_to do |format|
      format.any { render :nothing => true }
    end
  end
end
