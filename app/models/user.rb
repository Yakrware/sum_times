class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :supervisors, :association_foreign_key => :supervisor_id, :class_name => "User", :join_table => 'supervisor_users'
  has_and_belongs_to_many :supervises, :foreign_key => :supervisor_id, :class_name => "User", :join_table => 'supervisor_users'

  has_many :workdays do    
    def hours
      @workday_hours ||= begin
        ret = {}
        self.each do |l|
          l.hours.each do |h|
            ret[h["type"]] = 0 if !ret[h["type"]]
            next if h["end"].nil? || h["start"].nil?
            ret[h["type"]] += h["end"].to_f - h["start"].to_f
          end
        end
        ret
      end
    end
  end
  has_many :leaves
  has_many :leave_requests, :through => :supervises, :source => :leaves
  has_many :leave_transactions
  has_many :timesheets
  has_many :timesheets_to_accept, :through => :supervises, :source => :timesheets  
  belongs_to :company, autosave: true
  has_one :option, autosave: true, :dependent => :destroy, :inverse_of => :user
  alias_method :option_original, :option
  
  accepts_nested_attributes_for :option
  
  validates :name, :presence => true
  
  def option
    self.option_original || self.build_option
  end
  
  def accrued_hours
    @accrued_hours ||= begin
      multiplier = case self.option.leave_accrual_period
      when 'yearly' then
        (Time.now.at_beginning_of_year - self.created_at) / 1.year
      when 'monthly' then
        (Time.now.at_beginning_of_month - self.created_at) / 1.month
      when 'bi-monthly' then
        time = Time.now > Time.now.change({:day => 15}) ? Time.now.change({:day => 15}) : Time.now.at_beginning_of_month;
        months = 2 * (time - self.created_at) / 1.month
      when 'bi-weekly' then
        (Time.now.at_beginning_of_week - 3.days - self.created_at) / (1.week * 2)
      when 'bi-weekly-thursday' then
        (Time.now.at_beginning_of_week - 4.days - self.created_at) / (1.week * 2)
      when 'bi-weekly-sunday' then
        (Time.now.at_beginning_of_week - 1.day - self.created_at) / (1.week * 2)
      when 'weekly' then
        (Time.now.at_beginning_of_week - 3.days - self.created_at) / 1.week
      when 'weekly-thursday' then
        (Time.now.at_beginning_of_week - 4.days - self.created_at) / 1.week
      when 'weekly-sunday' then
        (Time.now.at_beginning_of_week - 1.days - self.created_at) / 1.week
      when 'daily' then
        (Time.now - self.created_at) / 1.day
      end.floor
      
      multiplier = 0 if multiplier < 0
      ret = {}
      self.option.leave_accrual.each do |k, v|
        ret[k] = v.to_f * multiplier
      end
      ret
    end
  end
  
  def available_hours
    @available_hours ||= begin
      total_hours = self.workdays.leave.hours
      initial_hours = self.option.leave_initial
      ret = {}
      self.accrued_hours.each do |k, v|
        next if k == 'unpaid'
        ret[k] = v.to_f - total_hours[k].to_f + initial_hours[k].to_f
      end
      ret
    end
  end
end
