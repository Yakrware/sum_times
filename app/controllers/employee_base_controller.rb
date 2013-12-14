class EmployeeBaseController < ApplicationController
  before_filter :authenticate_user!
  
  layout 'employee'
end
