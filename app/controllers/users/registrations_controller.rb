class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def create
    build_resource(sign_up_params)
    resource.admin = true # a new user is a company admin
    resource.company = Company.new(company_params)
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  protected
  def company_params
    params.require(:company).permit(:name)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
