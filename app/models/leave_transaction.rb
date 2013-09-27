class LeaveTransaction < ActiveRecord::Base

  validates :user_id, :presence => true
  validates :date, :presence => true
  validates :hours, :presence => true, :numericality => true

  belongs_to :user
end
