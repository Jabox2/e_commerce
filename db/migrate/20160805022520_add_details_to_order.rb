class AddDetailsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :name, :string
  end
end
