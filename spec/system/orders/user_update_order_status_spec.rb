require 'rails_helper'

describe 'Usuário informa novo status de pedido' do
  it 'e pedido foi entregue' do
    # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')

    product_a = ProductModel.create!(name: 'Produto A', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-A')

    order = Order.create(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :peding)
    item = OrderItem.create(order: order, product_model: product_a, quantity: 5)

  	# Act
  	login_as(user)
  	visit root_path
  	click_on 'Meus Pedidos'
  	click_on order.code
  	click_on 'Marcar como ENTREGUE'
  	# Assert
  	expect(current_path).to eq order_path(order.id)
  	expect(page).to have_content 'Situação do Pedido: Entregue'
  	expect(page).not_to have_content 'Marcar como ENTREGUE'
  	expect(page).not_to have_content 'Marcar como CANCELADO'
    result = StockProduct.count
    expect(result).to eq 5
  end

  it 'e pedido foi cancelado' do
    # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    product_a = ProductModel.create!(name: 'Produto A', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-A')

    order = Order.create(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: :peding)
    item = OrderItem.create(order: order, product_model: product_a, quantity: 5)

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como CANCELADO'
    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Situação do Pedido: Cancelado'
    expect(page).not_to have_content 'Marcar como ENTREGUE'
  	expect(page).not_to have_content 'Marcar como CANCELADO'
    result = StockProduct.count
    expect(result).to eq 0
  end
end
