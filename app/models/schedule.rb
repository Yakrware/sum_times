class Schedule < ActiveRecord::Base
  attr_accessor :date
  attr_accessible :end_date, :start_date, :user_id, :date

  belongs_to :user

  after_save :close_previous_schedule

  def days
    self[:days].nil? ? {} : JSON.parse(self[:days])
  end

  def days=(in_days)
    in_days.each do |key, val|
      val["hours"] = (val["start"].blank? || val["end"].blank?) ? 0 : ((Time.parse(val["end"]) - Time.parse(val["start"]))/3600 - val["lunch"].to_i)
    end
    self[:days] = in_days.to_json
  end

  def date=(in_date)
    @date = in_date.is_a?(Date) ? in_date : Date.parse(in_date)
  end

  def date
    @date ||= self[:date] ? Date.parse(self[:date]) : nil
  end

  def start
    self.days[self.date.days_to_week_start(:sunday).to_s]["start"]
  end

  def end
    self.days[self.date.days_to_week_start(:sunday).to_s]["end"]
  end

  def hours
    self.days[self.date.days_to_week_start(:sunday).to_s]["hours"]
  end

  def self.over_dates(start_date, end_date)
    end_date ||= start_date
    self.select("schedules.*, dates.date")
        .joins("JOIN generate_series('#{start_date.to_s}', '#{end_date.to_s}', INTERVAL '1 day') as dates ON dates.date >= schedules.start_date AND
                                                                                                            (dates.date <= schedules.end_date OR schedules.end_date IS NULL)")
  end

  def self.total_hours(user_id, start_date, end_date)
    holidays = Holiday.where("(start_date = :start AND end_date IS NULL) OR (start_date >= :start AND end_date <= :end)", :start => start_date, :end => end_date)
    self.over_dates(start_date, end_date).where(user_id: user_id).select{|s| holidays.index{|h| h.start_date == s.date || (h.start_date <= s.date && h.end_date >= s.date)}.nil?}.map(&:hours).sum
  end

  private
  def close_previous_schedule
    schedule = Schedule.where(user_id: self.user_id, end_date: nil).where("start_date < ?", self.start_date).order("start_date DESC").first # make this a bit smarter to ensure that schedules can't overlap
    schedule.update_attributes(end_date: self.start_date - 1.day) unless schedule.nil?
  end
end
