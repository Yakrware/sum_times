class EmployeesController < EmployeeBaseController
  before_filter :load_new_user, only: [:new]
  before_filter :load_create_user, only: [:create]
  load_and_authorize_resource class: "User"

  def index
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
  end

  # GET /employees/1/edit
  def edit
    @employee.build_option if @employee.option.nil?
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee.password = Devise.friendly_token
    @employee.build_option if @employee.option.nil?
    @employee.option.attributes = option_params[:option_attributes]

    respond_to do |format|
      if @employee.save
        NewEmployeeJob.new.async.perform(@employee.id)
        format.html { redirect_to employee_path(@employee), notice: 'Employee was successfully created.' }
      else
        flash[:errors] = @employee.errors.full_messages
        format.all { render "new" }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee.attributes = user_params
    @employee.build_option if @employee.option.nil?
    @employee.option.attributes = option_params[:option_attributes]
    
    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_path(@employee), notice: 'Employee was successfully changed.' }
      else
        flash[:errors] = @employee.errors.full_messages
        format.all { render "edit" }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
  
  private
  
  def load_new_user
    @employee = current_user.company.users.build
  end 
  
  def load_create_user
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
