class Workday < ActiveRecord::Base
  belongs_to :user
  has_one :company, :through => :user

  scope :on_date, ->(in_date) { joins(ActiveRecord::Base.send(:sanitize_sql_array, ["JOIN (SELECT w2.user_id, MAX(w2.date) AS date 
                                  FROM workdays w2
                                  WHERE (w2.recurring_days = '{}' AND w2.date = :date)
                                     OR (w2.date <= :date AND extract(dow from date(:date)) = ANY(w2.recurring_days) )
                                  GROUP BY w2.user_id 
                                 ) AS active USING (user_id, date)", :date => in_date]) ) }
  scope :today, -> { on_date(Date.today) }

  def self.workmonth(user, start)
    start ||= Date.today
    start = start.at_beginning_of_month
    true_start = start.at_beginning_of_week
    workweeks = []
    (0..(start.at_end_of_month.week_of_month-1)).each do |wom|
      week_start = true_start + wom.weeks
      workdays = []
      (-1..5).each do |dow|
        date = week_start + dow.days
        wd = Workday.where(user_id: user.id).on_date(date).first
        wd.date = date unless wd.nil?
        workdays << wd
      end
      workweeks << workdays
    end
    
    workweeks
  end

  private

  def notify_timesheet
    Timesheet.schedule_changed(self)
  end
end
