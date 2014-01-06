class EmployeeMailer < ActionMailer::Base
  default from: "admin@sumtimes.co"
  layout 'mailer'

  ##
  #   Mails an employee after they have been created
  ##
  def created(emp, token)
    @employee = emp
    @token = token
    
    mail to: @employee.email,
         subject: "You have been added to a company on sumtimes.co"
  end
end
