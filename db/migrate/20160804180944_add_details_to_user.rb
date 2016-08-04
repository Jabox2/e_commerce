class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    add_column :users, :username, :string
    add_column :users, :active_order_id, :integer
  end
end
