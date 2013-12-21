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
  scope :leave, -> { where(%Q[ '{"leave", "pto", "sick", "vacation", "unpaid"}' && pluck_from_json_array(hours, 'type') ]) }
  
  def self.workmonth(user, date)
    date ||= Date.today
    start_date = ((date.at_beginning_of_month + 1.day).at_beginning_of_week - 1.day).to_date
    end_date = ((date.at_end_of_month + 1.day).at_end_of_week - 1.day).to_date
    workdays = []
    (start_date..end_date).each do |d|
      wd = Workday.where(user_id: user.id).on_date(d).first
      wd.date = d unless wd.nil?
      workdays << wd
    end
    
    workdays.in_groups_of(7)
  end
  
  def hours
    self[:hours] || []
  end
  
  def punched_in?
    !hours.last.nil? && hours.last['end'].blank?
  end
  
  def close_pairs(time)
    hours.each do |h|
      if h["end"].blank?
        hours_will_change!
        h["end"] = time
      end
    end
  end
  
  def open_pair(time)
    hours_will_change!
    hours << {"start" => time}
  end
  
  def recurring?
    !recurring_days.blank?
  end
  
  def self.realize
    Workday.today.where("workdays.recurring_days != '{}'").each do |wd|
      if wd.user.option.salaried?
        wd.user.workdays.create date: Date.today, hours: wd.hours
      end
    end
  end
  
  def set_hours(in_hours = [])
    self.hours_will_change!
    self.hours = []
    self.hours_will_change!
    in_hours.each do |h|
      self.hours << {"start" => h[0], "end" => h[1], "type" => h[2]}
    end
    self.hours_will_change!
    self.hours.sort_by!{|h| h["start"]}
  end
  
  def total_hours(type = '')
    hours.reject{|h| h['start'].nil? || h['end'].nil? }.reject{|h| h['type'] == 'scheduled'}.select{|h| type == '' || h['type'] == type }.map do |h|
      h['end'].to_f - h['start'].to_f
    end.sum
  end
  
  private

  def notify_timesheet
    Timesheet.schedule_changed(self)
  end
end
