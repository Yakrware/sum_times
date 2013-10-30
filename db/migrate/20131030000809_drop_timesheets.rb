class DropTimesheets < ActiveRecord::Migration
  def change
    drop_table :timesheets
  end
end
