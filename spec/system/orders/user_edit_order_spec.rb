require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e deve estar autenticado' do
    # Arrange
    carlos = User.create!(name: 'Carlos', email: 'carlos@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    order = Order.create!(user: carlos, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    # Act
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
  	# Arrange
    carlos = User.create!(name: 'Carlos', email: 'carlos@gmail.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
    order = Order.create!(user: carlos, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    # Act
    login_as(carlos)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: 2.day.from_now
    select 'Spark Industries Brasil LTDA', from: 'Fornecedor'
    click_on 'Gravar'

    # Assert
    expect(page).to have_content('Pedido atualizado com sucesso.')
    expect(page).to have_content('Galpão Destino: SDU - Rio')
    expect(page).to have_content('Fornecedor: Spark Industries Brasil LTDA - 24785893000196')
    formatted_date = I18n.localize(2.day.from_now.to_date)
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'caso seja responsável' do
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
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq root_path
  end
end