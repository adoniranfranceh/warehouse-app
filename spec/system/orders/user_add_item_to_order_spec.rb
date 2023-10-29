require 'rails_helper'

describe 'Usuário adiciona itens ao pedido' do
  it 'com sucesso' do
  	# Arrange
  	user = User.create!(name: 'User', email: 'user@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                                  address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                                full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier, sku: 'PRODUTO-B')

  	# Act
  	login_as(user)
  	visit root_path
  	click_on('Meus Pedidos')
  	click_on(order.code)
  	click_on('Adicionar Item')
  	select 'Produto A', from: 'Produto'
  	fill_in 'Quantidade', with: '8'
  	click_on('Gravar')

  	# Assert
  	expect(current_path).to eq order_path(order.id)
  	expect(page).to have_content('Item adicionado com sucesso.')
  	expect(page).to have_content('8 x Produto A')
  end

  it 'e não vê produtos de outros fornecedores' do
  	# Arrange
  	user = User.create!(name: 'User', email: 'user@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                                  address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier_a = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                               	  full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    supplier_b = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    							full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, estimated_delivery_date: 1.day.from_now)
    product_a = ProductModel.create!(name: 'Produto A', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier_a, sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', width: 10, weight: 15, height: 20, depth: 30, supplier: supplier_b, sku: 'PRODUTO-B')

  	# Act
  	login_as(user)
  	visit root_path
  	click_on('Meus Pedidos')
  	click_on(order.code)
  	click_on('Adicionar Item')

  	# Assert
  	expect(page).to have_content('Produto A')
		expect(page).not_to have_content('Produto B')
	end
end
