class AddAttributesToWarehouse < ActiveRecord::Migration[6.1]
  def change
    add_column :warehouses, :cep, :string
    add_column :warehouses, :description, :string
  end
end
