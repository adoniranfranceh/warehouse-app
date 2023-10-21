require 'rails_helper'

describe 'Usuário vê detalhes do fornecedor' do
  it 'a partir da tela inicial' do
  	# Arrange
  	Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
  	# Act
  	visit root_path
  	click_on 'Fornecedores'
  	click_on 'ACME'

  	# Assert
  	expect(page).to have_content('ACME LTDA')
  	expect(page).to have_content('Documento: 56144734000107')
  	expect(page).to have_content('Endereço: Av das Palmas, 100 - Bauru - SP')
  	expect(page).to have_content('E-mail: contato@gmail')
  end

  it 'e volta para a tela inicial' do
  	# Arrange
  	Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
	# Act
	visit root_path
  	click_on 'Fornecedores'
  	click_on 'ACME'
  	click_on 'Voltar'

	# Assert
	expect(current_path).to eq root_path
  end
end
