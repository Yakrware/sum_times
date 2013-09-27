class Company < ActiveRecord::Base
  has_many :users
  has_many :accruals
  has_many :holidays
end
