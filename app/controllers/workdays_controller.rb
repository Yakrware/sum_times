class WorkdaysController < EmployeeController
  load_and_authorize_resource :workday, except: [:own, :create]
    
  def index
    @workdays = @workdays.today
  end
  
  def own
    @workweeks = Workday.workmonth(current_user, params[:start])
  end

  def show
  end

  def new
    params[:date] = (params[:date] || Date.today).to_date
    @workday = Workday.new(user_id: params[:user_id] || current_user.id, date: params[:date])
  end

  def create
    @workday = Workday.new(workday_params)
    authorize! :create, @workday

    if @workday.save
      redirect_to own_workdays_path
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
      redirect_to own_workdays_path
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
