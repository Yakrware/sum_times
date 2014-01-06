class LateMailer < ActionMailer::Base
  default from: "admin@sumtimes.co"

  def late(late)
    @late = late
    @supervisors = @late.user.supervisors

    mail to: @supervisors.map(&:email),
         subject: "#{@late.user.name} is running late"
  end
end
