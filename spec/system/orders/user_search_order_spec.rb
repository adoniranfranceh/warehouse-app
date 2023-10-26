require 'rails_helper'

describe 'Usuário buscar por pedido' do
  it 'a partir do menu' do
  	# Arrange
    user = User.create!(name: 'Adoniran', email: 'adoniran@email.com', password: 'password')
    # Act
    login_as(user)
    visit root_path
    # Assert
    within('header nav') do
      expect(page).to have_field('Buscar Pedidos')
      expect(page).to have_button('Buscar')
    end
  end

  it 'e deve estar autenticado' do
  	# Arrange

  	# Act
    visit root_path
  	# Assert
  	within('header nav') do
      expect(page).not_to have_field('Buscar Pedidos')
      expect(page).not_to have_button('Buscar')
    end
  end

  it 'e encontra um pedido' do
  	# Arrange
  	user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    order = Order.create(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

  	# Act
  	login_as(user)
    visit root_path
    fill_in 'Buscar Pedidos', with: order.code
    click_on 'Buscar'

  	# Assert
  	expect(page).to have_content("Resultado da busca por: #{order.code}")
  	expect(page).to have_content('1 pedido encontrado')
  	expect(page).to have_content('Galpão Destino: SDU - Rio')
  	expect(page).to have_content('Fornecedor: Spark Industries Brasil LTDA - 24785893000196')
  end
end
