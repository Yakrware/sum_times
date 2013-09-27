class LatesController < EmployeeController

  respond_to :js

  # POST /lates
  # POST /lates.json
  def create
    @late = Late.create(date: Date.today, user_id: current_user.id)

    LateMailer.late(@late).deliver

    redirect_to schedule_path(current_user.id)
  end
end
