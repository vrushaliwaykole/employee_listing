class AddDeletedDetailsToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :is_deleted, :boolean
  	add_column :employees, :deleted_at, :datetime
  end
end
