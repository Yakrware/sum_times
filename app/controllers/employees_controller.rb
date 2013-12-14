class EmployeesController < EmployeeBaseController
  before_filter :load_new_user, only: [:create]
  load_and_authorize_resource class: "User"

  def index
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @employee.build_option
  end

  # GET /profiles/1/edit
  def edit
    @employee.build_option if @employee.option.nil?
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @employee.password = Devise.friendly_token
    @employee.build_option if @employee.option.nil?
    @employee.option.attributes = option_params[:option_attributes]

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_path(@employee), notice: 'Profile was successfully created.' }
      else
        flash[:errors] = @employee.errors.full_messages
        format.all { render "new" }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @employee.attributes = user_params
    @employee.build_option if @employee.option.nil?
    @employee.option.attributes = option_params[:option_attributes]
    
    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_path(@employee), notice: 'Profile was successfully changed.' }
      else
        flash[:errors] = @employee.errors.full_messages
        format.all { render "edit" }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
  
  private
  
  def load_new_user
    @employee = current_user.company.users.build user_params
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :active, :admin)
  end
  
  def option_params
    params.require(:user).permit(:name, option_attributes: {value: [:scheduling, :wage, :pay_period, :day_start, :day_end, :leave_accrual_period, 
                                                                       :leave_types => [], :leave_accrual => [:pto, :sick, :vacation, :unpaid],
                                                                       :leave_initial => [:pto, :sick, :vacation, :unpaid] ]})
  end
end
