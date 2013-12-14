class CompaniesController < EmployeeBaseController
  load_and_authorize_resource :company, :through => :current_user, :singleton => true
  
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @company.update company_params
        unless @company.option.persisted? # catch odd case where a new option isn't saving
          @company.option.update company_params[:option_attributes]
        end
        format.any { redirect_to company_path }
      else
        format.any { render 'edit', errors: @company.errors.full_messages }
      end
    end    
  end
  
  protected
  def company_params
    params.require(:company).permit(:name, option_attributes: {value: [:scheduling, :wage, :pay_period, :day_start, :day_end, :leave_accrual_period, 
                                                                       :leave_types => [], :leave_accrual => [:pto, :sick, :vacation, :unpaid],
                                                                       :leave_initial => [:pto, :sick, :vacation, :unpaid] ]})
  end
end
