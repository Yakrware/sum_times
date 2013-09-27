class ChangeWorkdaysRemoveLeaves < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :workdays do |t|
        t.string :category
      end
      
      dir.up { drop_table :leaves }
      dir.down do  
        create_table "leaves", force: true do |t|
          t.integer  "user_id"
          t.text     "reason"
          t.integer  "hours"
          t.string   "category"
          t.date     "start_date"
          t.date     "end_date"
          t.boolean  "approved"
          
          t.timestamps
        end
      end
  end
end
