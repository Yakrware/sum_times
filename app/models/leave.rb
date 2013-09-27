class Leave < Workday
  default_scope -> { where(category: ['sick', 'vacation', 'pto', 'unpaid'] ) }
end
