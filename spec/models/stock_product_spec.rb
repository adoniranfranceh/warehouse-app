require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'gera um número de serie' do
    it 'ao criar um StockProduct' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
      product_a = ProductModel.create!(name: 'Produto A', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-A')
      order = Order.create(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :delivered)

      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)

      # Assert
      expect(stock_product.serial_number.length).to eq 20
    end

    it 'e não é modificado' do
       # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
      other_warehouse = Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                    address: 'Av Atlantica, 80', cep: '80000-000', description: 'Perto do Aeroporto')
      supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
      product_a = ProductModel.create!(name: 'Produto A', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-A')
      order = Order.create(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :delivered)
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a)
      original_serial_number = stock_product.serial_number
      # Act
      stock_product.update!(warehouse: other_warehouse)

      # Assert
      expect(stock_product.serial_number).to eq original_serial_number
    end
  end
end
