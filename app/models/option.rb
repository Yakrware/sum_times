class Option < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  
  validate :user_xor_company


  DEFAULT = {
    scheduling: 'flex', # scheduled
    wage: 'salaried', # hourly
    pay_period: 'monthly', # weekly bi-weekly bi-monthly
    day_start: 6, # 0-23
    day_end: 20, # 1-24,
    leave_accrual_period: 'monthly',
    leave_types: ['vacation', 'sick', 'unpaid'],
    leave_accrual: {vacation: 8, sick: 8},
    leave_initial: {vacation: 0, sick: 0}
  }.with_indifferent_access
  
  def value
    if self.user # if it's a user, merge into the company options
      self.user.company.option.value.merge(self[:value].to_h)
    else
      DEFAULT.merge(self[:value].to_h)
    end
  end
  
  def value=(val)
    if self.user
      val.reject!{|k,v| self.user.company.option.value[k] == v }
    end
    self[:value] = val
  end
  
  def salaried?
    value["wage"] == "salaried"
  end
  
  def hourly?
    value["wage"] == "hourly"
  end
  
  def flex?
    value["scheduling"] == "flex"
  end
  
  def scheduled?
    value["scheduling"] == "scheduled"
  end
  
  def method_missing(meth, *args, &block)
    if value.has_key? meth.to_s
      value[meth.to_s]
    else
      super
    end
  end

  private

  def user_xor_company
    if !(user.blank? ^ company.blank?)
      errors.add(:base, "Specify a user or company, but not both")
    end
  end

end
