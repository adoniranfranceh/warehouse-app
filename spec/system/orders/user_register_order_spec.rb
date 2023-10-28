require 'rails_helper'

describe 'Usuário cadastra um pedido' do
	it 'e deve estar autenticado' do
		# Arrange

		# Act
		visit root_path
		click_on 'Cadastrar pedido'

		# Assert
		expect(current_path).to eq new_user_session_path
	end

  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
    Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                    address: 'Av Atlantica, 80', cep: '80000-000', description: 'Perto do Aeroporto')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

  	# Act
  	login_as(user)
  	visit root_path
  	click_on 'Cadastrar pedido'
  	select 'SDU - Rio', from: 'Galpão Destino'
    select 'Spark Industries Brasil LTDA - 24785893000196', from: 'Fornecedor'
  	fill_in 'Data Prevista de Entrega', with: '22/12/2023'
  	click_on 'Gravar'

  	# Assert
    expect(page).to have_content 'Pedido registrado com sucesso.'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Galpão Destino: SDU - Rio'
    expect(page).to have_content 'Fornecedor: Spark Industries Brasil LTDA - 24785893000196'
    expect(page).to have_content 'Usuário Responsável: Sergio - sergio@email.com'
    expect(page).to have_content 'Data Prevista de Entrega: 22/12/2023'
    expect(page).to have_content 'Situação do Pedido: Pendente'
  end

  it 'e data estimada de entrega é igual a hoje' do
     # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
    Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                    address: 'Av Atlantica, 80', cep: '80000-000', description: 'Perto do Aeroporto')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    # Act
    login_as(user)
    visit root_path
    click_on 'Cadastrar pedido'
    select 'SDU - Rio', from: 'Galpão Destino'
    select 'Spark Industries Brasil LTDA - 24785893000196', from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: Date.today
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Não foi possível registrar um pedido.'
    expect(page).to have_content 'Data Prevista de Entrega deve ser futura'
  end

  it 'e não informa data estimada de entrega' do
    # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: 'password')
    Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                    address: 'Av Atlantica, 80', cep: '80000-000', description: 'Perto do Aeroporto')
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
    supplier = Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '24785893000196',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')

    # Act
    login_as(user)
    visit root_path
    click_on 'Cadastrar pedido'
    select 'SDU - Rio', from: 'Galpão Destino'
    select 'Spark Industries Brasil LTDA - 24785893000196', from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: ''
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Não foi possível registrar um pedido.'
    expect(page).to have_content 'Data Prevista de Entrega não pode ficar em branco'
  end
end
