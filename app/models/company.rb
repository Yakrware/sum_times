class Company < ActiveRecord::Base
  has_many :users
  has_many :accruals
  has_many :holidays
  has_one :option, autosave: true, :dependent => :destroy, :inverse_of => :company
  
  accepts_nested_attributes_for :option
  
  validates :name, :presence => true
  
  def option
    super || option = Option.new(company_id: self.id)
  end
end
