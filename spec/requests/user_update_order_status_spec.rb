require 'rails_helper'

describe 'Usuário informa novo status de um pedido' do
  it 'e não é dono' do
    # Arrange
    carlos = User.create!(name: 'Carlos', email: 'carlos@gmail.com', password: 'password')
    andre = User.create!(name: 'André', email: 'andre@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
    order = Order.create!(user: carlos, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    # Act
    login_as(andre)
    post(delivered_order_path(order.id))
    # Assert
    expect(response).to redirect_to(root_path)
	end
end
