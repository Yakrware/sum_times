class NeuterSchedule < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.down { rename_table :workdays, :schedules }
    
      change_table :schedules do |t|
        dir.up do
          t.remove :days, :start_date, :end_date
          t.date :date
          t.json :hours
          t.integer :recurring_days, array: true, default: []
        end
        dir.down do
          t.string :days
          t.date :start_date
          t.date :end_date
          t.remove :date, :hours, :recurring_days
        end
      end
      
      dir.up { rename_table :schedules, :workdays }
    end
  end
end
