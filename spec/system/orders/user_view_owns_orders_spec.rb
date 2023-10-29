require 'rails_helper'

describe 'Usuário vé seus próprios pedidos' do
  it 'e deve estar autenticado' do
  	# Arrange

  	# Act
    visit root_path
    click_on('Meus Pedidos')
  	# Assert
  	expect(current_path).to eq new_user_session_path
  end

  it 'e não vê outros pedidos' do
  	# Arrange
  	carlos = User.create!(name: 'Carlos', email: 'carlos@gmail.com', password: 'password')
  	maria = User.create!(name: 'Maria', email: 'maria@gmail.com', password: 'password')
  	warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
  	first_order = Order.create!(user: carlos, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
  	second_order = Order.create!(user: maria, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
  	third_order = Order.create!(user: carlos, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.week.from_now)
  	# Act
  	login_as(carlos)
  	visit root_path
  	click_on 'Meus Pedidos'
  	# Assert
  	expect(page).to have_content(first_order.code)
  	expect(page).not_to have_content(second_order.code)
  	expect(page).to have_content(third_order.code)
  end

  it 'e visita um pedido' do
    # Arrange
    carlos = User.create!(name: 'Carlos', email: 'carlos@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    order = Order.create!(user: carlos, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    # Act
    login_as(carlos)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    # Assert
    expect(page).to have_content('Detalhes do Pedido')
    expect(page).to have_content(order.code)
    expect(page).to have_content('Galpão Destino: SDU - Rio')
    expect(page).to have_content('Fornecedor: Spark Industries Brasil LTDA - 24785893000196')
    formatted_date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'e não visita pedidos de outros usuários' do
     # Arrange
    carlos = User.create!(name: 'Carlos', email: 'carlos@gmail.com', password: 'password')
    andre = User.create!(name: 'André', email: 'andre@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    order = Order.create!(user: carlos, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    # Act
    login_as(andre)
    visit order_path(order.id)

    # Assert
    expect(current_path).not_to eq order_path(order.id)
    expect(page).to have_content('Você não possui acesso a este pedido.')
  end

  it 'e vê itens do pedido' do
    # Arrange
    user = User.create!(name: 'User', email: 'user@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                                  address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                                full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-B')
    product_c = ProductModel.create!(name: 'Produto C', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-C')
    OrderItem.create!(product_model: product_a, order: order, quantity: 19)
    OrderItem.create!(product_model: product_b, order: order, quantity: 15)

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    # Assert
    expect(page).to have_content('Itens do Pedido')
    expect(page).to have_content('19 x Produto A')
    expect(page).to have_content('15 x Produto B')
  end
end
