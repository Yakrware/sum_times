class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :user_id
      t.integer :company_id
      t.json :value

      t.timestamps
    end
  end
end
