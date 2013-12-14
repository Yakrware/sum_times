class LeavesController < EmployeeBaseController
  load_and_authorize_resource :workday, :parent => false

  def index
    @user = current_user
    @user = User.find(params[:user_id]) if params[:user_id] && can?(:manage, Workday)
    @past = params[:past].present?
    
    @date = (params[:date] || Date.today).to_date
    @workdays = @workdays.order(:date).leave
    if(@past)
      @workdays = @workdays.where("date < ?", @date)
    else
      @workdays = @workdays.where("date >= ?", @date)
    end
                         
    if can? :manage, Workday # if we're an admin, the ability will pick up too many users, limit to just one
      @workdays = @workdays.where(:user_id => params[:user_id] || current_user.id)
    end
  end

  def new
    @date = (params[:date] || Date.today).to_date
    @user = current_user
    @user = User.find(params[:user_id]) if params[:user_id] && can?(:manage, Workday)
    
    @workday = @user.workdays.on_date(@date).first
    if @workday.nil? || @workday.recurring?
      hours = @workday.nil? ? [] : @workday.hours
      @workday = @user.workdays.build(date: @date, hours: hours)
    end
    @workday.hours.each{|h| h['type'] = @user.option.leave_types.first}
  end
  
  def edit
  end
  
  def create
    @user = leave_params[:user_id] ? User.find(leave_params[:user_id]) : current_user
    date = leave_params[:date].to_date
    type = leave_params[:type]
    
    #authorize the creation of workdays for this user. Use a blank workday so we only have to authorize once
    authorize! :create, Workday.new(user: @user)
    
    # loop through hour sets
    leave_params[:hours].each.with_index do |hours, i|
      next if hours.blank? || hours == '[]'
      # check each workday
      workday = @user.workdays.on_date(date + i.days).first
      # create new ones if required
      if workday.nil? || workday.recurring?
        workday = @user.workdays.build(date: date + i.days)
      else
        workday = Workday.find(workday.id) # reload workday to avoid a read-only record
      end
      # set hours for leave
      workday.hours = hours
      workday.save
    end
    
    redirect_to leaves_path
  end
  
  def update
    @workday.hours = leave_params[:hours]
    @workday.save
    
    respond_to do |format|
      format.json { render :json => {} }
      format.html { redirect_to leaves_path(past: true) }
      format.any { render :nothing => true }
    end
  end

  def destroy
    @workday.destroy
        
    respond_to do |format|
      format.html { redirect_to leaves_path }
      format.json { render :json => {} }
      format.any { render :nothing => true }
    end
  end

  private
    
  def leave_params
    params.require(:leave).permit(:date, :type, :user_id).tap do |whitelist|
      whitelist[:hours] = params[:leave][:hours]
    end
  end
end
