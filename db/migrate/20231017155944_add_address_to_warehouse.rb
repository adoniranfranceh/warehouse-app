class AddAddressToWarehouse < ActiveRecord::Migration[6.1]
  def change
    add_column :warehouses, :address, :string
  end
end
