class Accrual < ActiveRecord::Base
  attr_accessible :month, :year

  validates :month, :presence => true, :uniqueness => {:scope => :year}
  validates :year, :presence => true

  before_create :add_times_to_users

  def self.generate_for_month
    Accrual.create(month: Date.today.month, year: Date.today.year)
  end

  private
  def add_times_to_users
    User.where(active: true).each do |user|
      LeaveTransaction.create user_id: user.id, date: Date.today.at_beginning_of_month.change(:month => self.month, :year => self.year), category: 'vacation', hours: user.accrues_vacation
      LeaveTransaction.create user_id: user.id, date: Date.today.at_beginning_of_month.change(:month => self.month, :year => self.year), category: 'sick', hours: user.accrues_sick
    end
  end
end
