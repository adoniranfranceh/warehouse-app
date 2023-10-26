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
end
