class ChangeWorkdaysAddDefault < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up { change_column :workdays, :hours, :json, :default => '[]' }
      dir.down { change_column :workdays, :hours, :json, :default => nil }
    end
  end
end
