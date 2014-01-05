class DeviseBaseController < ApplicationController
  skip_before_filter :check_paid
  
  layout :choose_layout
    
  protected
  def choose_layout
    case self.controller_name
    when 'registrations' then self.action_name == 'edit' ? 'application' : 'devise'
    else 'devise'
    end
  end
end
