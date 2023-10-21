require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'a partir da página de detalhes' do
  	# Arrange
  	Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
  	# Act
  	visit root_path
  	click_on 'Fornecedores'
  	click_on 'Spark'
  	click_on 'Editar'

  	# Asset
  	expect(page).to have_content('Editar Fornecedor Spark')
  	expect(page).to have_field('Nome Fantasia', with: 'Spark')
  	expect(page).to have_field('Razão Social', with: 'Spark Industries Brasil LTDA')
  	expect(page).to have_field('CNPJ', with: '56144734000107')
  	expect(page).to have_field('Endereço', with: 'Torre da Indústria, 1')
  	expect(page).to have_field('Cidade', with: 'Teresina')
  	expect(page).to have_field('Estado', with: 'PI')
  	expect(page).to have_field('E-mail', with: 'vendedor@gmail.com')
  end

  it 'com sucesso' do
  	# Arrange
  	Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')

  	# Act
  	visit root_path
  	click_on 'Fornecedores'
  	click_on 'Spark'
  	click_on 'Editar'
  	fill_in 'E-mail', with: 'vendedor@outlook.com'
  	click_on 'Enviar'

  	# Assert
  	expect(page).to have_content 'Fornecedor atualizado com sucesso.'
  	expect(page).to have_content 'Documento: 56144734000107'
  	expect(page).to have_content 'Endereço: Torre da Indústria, 1 - Teresina - PI'
  	expect(page).to have_content 'E-mail: vendedor@outlook.com'
  end

  it 'e mantém os campos obrigatórios' do
  	# Arrange
  	Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')

  	# Act
  	visit root_path
  	click_on 'Fornecedores'
  	click_on 'Spark'
  	click_on 'Editar'
  	fill_in 'E-mail', with: ''
  	click_on 'Enviar'

  	# Assert
  	expect(page).to have_content 'Fornecedor não atualizado.'
  end
end
