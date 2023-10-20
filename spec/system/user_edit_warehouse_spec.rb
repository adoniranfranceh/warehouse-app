require 'rails_helper'

describe 'Usuário edita um galpão' do
  it 'a partir da página de detalhes' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')
    # Act
    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Editar'

    # Assert
    expect(page).to have_content 'Editar Galpão'
    expect(page).to have_field('Nome', with: 'Aeroporto SP')
    expect(page).to have_field('Código', with: 'GRU')
    expect(page).to have_field('Cidade', with: 'Guarulhos')
    expect(page).to have_field('Área', with: '100000')
    expect(page).to have_field('Endereço', with: 'Avenida do Aeroporto, 1000')
    expect(page).to have_field('CEP', with: '15000-000')
    expect(page).to have_field('Descrição', with: 'Galpão destinado para cargas internacionais')
  end

  it 'com sucesso' do
  	# Arrange
  	warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')
  	# Act
  	visit root_path
    click_on 'Aeroporto SP'
    click_on 'Editar'
    fill_in 'Nome', with: 'Galpão internacional'
    fill_in 'Área', with: '200000'
    fill_in 'Endereço', with: 'Avenida dos Galpões, 500'
    fill_in 'CEP', with: '16000-000'
    click_on 'Enviar'

  	# Assert
  	expect(page).to have_content 'Galpão atualizado com sucesso.'
  	expect(page).to have_content 'Galpão internacional'
  	expect(page).to have_content '200000'
  	expect(page).to have_content 'Avenida dos Galpões, 500'
  	expect(page).to have_content '16000-000'
  end

  it 'e mantém os campos obrigatórios' do
  	# Arrage
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                 address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                 description: 'Galpão destinado para cargas internacionais')  	

  	# Act
  	visit root_path
  	click_on 'Aeroporto SP'
  	click_on 'Editar'

  	fill_in 'Nome', with: ''
  	fill_in 'Área', with: ''
  	fill_in 'Endereço', with: ''
  	click_on 'Enviar'

  	# Assert
  	expect(page).to have_content 'Não foi possivel atualizar o galpão.'
  end
end