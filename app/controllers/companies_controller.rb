class CompaniesController < EmployeeBaseController
  load_and_authorize_resource :company, :through => :current_user, :singleton => true
  
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @company.update company_params
        format.any { redirect_to company_path }
      else
        format.any { render 'edit', errors: @company.errors.full_messages }
      end
    end    
  end
  
  protected
  def company_params
    params.require(:company).permit(:name, option_attributes: {value: [:scheduling, :wage, :pay_period, :day_start, :day_end]})
  end
end
