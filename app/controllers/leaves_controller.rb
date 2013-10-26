class LeavesController < EmployeeBaseController
  load_and_authorize_resource :leave, :except => [:index]

  def index
    @leaves = current_user.leaves
  end

  def show
  end

  def new
    @leave = Leave.new(user_id: params[:user_id] || current_user.id)
  end

  def create
    @leave = Leave.new(leave_params)
    authorize! :create, @leave
    
    if @leave.save
      LeaveMailer.req(@leave).deliver
    end
    respond_with(@leave)
  end

  def update
    use_params = @leave.user_id != current_user.id ? supervisor_params : leave_params
    
    @leave.update_attributes(use_params)

    if params[:leave][:approved]
      LeaveMailer.accept(@leave, current_user).deliver
    end

    respond_with(@leave) do |format|
      format.all {redirect_to leaves_path}
    end
  end

  def destroy
    @leave.destroy

    if @leave.user_id != current_user.id
      LeaveMailer.deny(@leave, current_user).deliver
    end

    if request.referrer == leaves_url
      redirect_to leaves_path
    else
      redirect_to edit_profiles_path
    end
  end

  private

  def supervisor_params
    params.require(:leave).permit!
  end
  
  def leave_params
    params.require(:leave).permit!
  end
end
