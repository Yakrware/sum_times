class TimesheetMailer < ActionMailer::Base
  default from: "admin@sumtimes.co"

  ##
  #   Mails all admins in the system their timesheets
  ##
  def generated
  end
end
