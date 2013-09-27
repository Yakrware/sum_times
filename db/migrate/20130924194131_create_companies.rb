class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name

      t.timestamps
    end    
    
    add_column :accruals, :company_id, :integer
    add_column :holidays, :company_id, :integer
    add_column :users, :company_id, :integer
    add_column :users, :admin, :boolean, :default => false
  end
end
