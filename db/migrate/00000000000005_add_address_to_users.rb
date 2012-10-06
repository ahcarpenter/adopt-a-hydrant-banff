class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :city, :string
    add_column :users, :area, :string
    add_column :users, :zip, :string
  end
end