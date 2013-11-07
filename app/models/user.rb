class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :supervisors, :association_foreign_key => :supervisor_id, :class_name => "User", :join_table => 'supervisor_users'
  has_and_belongs_to_many :supervises, :foreign_key => :supervisor_id, :class_name => "User", :join_table => 'supervisor_users'

  has_many :workdays
  has_many :leaves
  has_many :leave_requests, :through => :supervises, :source => :leaves
  has_many :leave_transactions
  has_many :timesheets
  has_many :timesheets_to_accept, :through => :supervises, :source => :timesheets  
  belongs_to :company, autosave: true
  has_one :option, autosave: true, :dependent => :destroy
  alias_method :option_original, :option
  
  accepts_nested_attributes_for :option
  
  validates :name, :presence => true
  
  def current_schedule
    self.schedules.where('start_date <= :date AND (end_date >= :date OR end_date IS NULL)', :date => Date.today).first
  end

  def future_schedules
    self.schedules.where('start_date > :date', :date => Date.today)
  end

  def vacation_hours
    self.transaction_hours('vacation')
  end

  def sick_hours
    self.transaction_hours('sick')
  end

  def accrues_vacation
    # eventually read this out of a yml file
    self[:accrues_vacation] || 6.67
  end

  def accrues_sick
    # eventually read this out of a yml file
    self[:accrues_sick] || 8
  end

  def option
    self.option_original || self.build_option
  end
  
  protected
  def transaction_hours(category)
    self.leave_transactions.select('SUM(hours) as hours').where('date <= ?', Date.today).where(category: category).first[:hours] || 0
  end
end
