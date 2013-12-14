class WorkdaysController < EmployeeBaseController
  load_and_authorize_resource :workday, except: [:own, :create]
    
  def index
    @date = (params[:date] || Date.today).to_date
    @workdays = @workdays.on_date(@date)
  end
  
  def show
    @user = current_user
    @user = User.find(params[:user_id]) if params[:user_id] && can?(:manage, Workday)
    @workweeks = Workday.workmonth(@user, params[:start])
  end
  
  def on_date
    @user = current_user
    @user = User.find(params[:user_id]) if params[:user_id] && can?(:manage, Workday)
    @date = params[:date].to_date
    @workday = @user.workdays.on_date(@date).first
  end

  def new
    user_id = params[:user_id] || current_user.id
    user = current_user.company.users.find(user_id)
    params[:date] = (params[:date] || Date.today).to_date
    day = Workday.where(user_id: user_id).on_date(params[:date]).first
    hours = day.nil? ? [{"start" => user.option.day_start, "end" => user.option.day_end}] : day.hours
    @workday = Workday.new(user_id: user_id, date: params[:date], hours: hours)
    authorize! :schedule, @workday
  end

  def create
    @workday = Workday.new(workday_params)
    authorize! :schedule, @workday

    if @workday.save
      redirect_to show_workdays_path
    else
      respond_with(@workday) do
        format.html {render 'new'}
      end
    end
  end
  
  def edit
  end

  def update
    @workday.attributes = workday_params
    authorize! :update, @workday

    if @workday.save
      redirect_to show_workdays_path
    else
      respond_with(@workday) do
        format.html {render 'new'}
      end
    end
  end

  def destroy
    if @workday && @workday.destroy
      respond_with(@workday) do |format|
        format.html {render :nothing => true}
      end
    else
      respond_with(@workday)
    end
  end

  private
  
  def workday_params
    params[:workday][:recurring_days] = params[:workday][:recurring_days].map{|d| d.to_i} if params[:workday][:recurring_days]
    params.require(:workday).permit!
  end
end
