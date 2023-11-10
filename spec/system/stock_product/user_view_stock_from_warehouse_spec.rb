require 'rails_helper'

describe 'Usuário vê o estoque' do
  it 'na tela do galpão' do
  	# Arrange
    user = User.create!(name: 'André', email: 'andre@remail.com', password: 'password')
  	w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
  		              address: 'Avenida do Aeroporto, 1000', cep: '15000-00',
  		              description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '93648500000115',
                                full_address: 'Av Nacoes Unidas',
                                city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    product_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 40, depth: 10,
                                      sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
    product_soundbar = ProductModel.create!(name: 'SoundBar 7.1 Surround', weight: 3000, width: 80, height: 40, depth: 10,
                                      sku: 'SOU71-SAMSU-NOIZ77', supplier: supplier)
    product_notebook = ProductModel.create!(name: 'Notebook i5 16GB RAM', weight: 2000, width: 40, height: 9,
                         depth: 20, sku: 'NOTEI5-SAMSU-TLI99',supplier: supplier)
    3.times { StockProduct.create!(order: order, warehouse: w, product_model: product_tv) }
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: product_notebook) }

    # Act
    login_as(user)
    visit root_path
    click_on 'Aeroporto SP'

    # Assert
    within('section#stock_products') do
      expect(page).to have_content('Itens em Estoque')
      expect(page).to have_content('3 x TV32-SAMSU-XPTO90')
      expect(page).to have_content('2 x NOTEI5-SAMSU-TLI99')
      expect(page).not_to have_content('SOU71-SAMSU-NOIZ77')
    end
  end

  it 'e dá baixa em um item' do
    # Arrange
    user = User.create!(name: 'André', email: 'andre@remail.com', password: 'password')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1000', cep: '15000-00',
                    description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '93648500000115',
                                full_address: 'Av Nacoes Unidas',
                                city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    product_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 40, depth: 10,
                                      sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: product_tv) }

    # Act
    login_as(user)
    visit root_path
    click_on 'Aeroporto SP'
    select 'TV32-SAMSU-XPTO90', from: 'Item para Saída'
    fill_in 'Destinatário', with: 'Maria Ferreira'
    fill_in 'Endereço Destino', with: 'Rua das Palmeiras, 100 - Campinas - São Paulo'
    click_on 'Confirmar Retirada'

    # Assert
    expect(current_path).to eq warehouse_path(w.id)
    expect(page).to have_content('Item retirado com sucesso')
    expect(page).to have_content('1 x TV32-SAMSU-XPTO90')
  end

  it 'e vê apenas item que existe no galpão' do
    # Arrange
    user = User.create!(name: 'André', email: 'andre@remail.com', password: 'password')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1000', cep: '15000-00',
                    description: 'Galpão destinado para cargas internacionais')
    other_w = Warehouse.create!(name: 'Cuiaba', code: 'CWB',area: 10000, cep: '56000-000',
                                  city: 'Cuiabá', description: 'Galpão no centro do país', address: 'Av dos Jacarés, 1000')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '93648500000115',
                                full_address: 'Av Nacoes Unidas',
                                city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    product_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 40, depth: 10,
                                      sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
    product_notebook = ProductModel.create!(name: 'Notebook i5 16GB RAM', weight: 2000, width: 40, height: 9,
                         depth: 20, sku: 'NOTEI5-SAMSU-TLI99',supplier: supplier)
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: product_tv) }
    2.times { StockProduct.create!(order: order, warehouse: other_w, product_model: product_notebook) }


    # Act
    login_as(user)
    visit root_path
    click_on 'Aeroporto SP'

    # Assert
    expect(current_path).to eq warehouse_path(w.id)
    expect(page).not_to have_content('2 x NOTEI5-SAMSU-TLI99')
    expect(page).to have_content('2 x TV32-SAMSU-XPTO90')
  end

  it 'e dá baixa em um item' do
    # Arrange
    user = User.create!(name: 'André', email: 'andre@remail.com', password: 'password')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                    address: 'Avenida do Aeroporto, 1000', cep: '15000-00',
                    description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                                registration_number: '93648500000115',
                                full_address: 'Av Nacoes Unidas',
                                city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    product_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 40, depth: 10,
                                      sku: 'TV32-SAMSU-XPTO90', supplier: supplier)
    1.times { StockProduct.create!(order: order, warehouse: w, product_model: product_tv) }
    StockProductDestination.create!(stock_product: StockProduct.first,
                                   recipient: 'Maria Ferreira',
                                   address: 'Rua das Palmeiras, 100 - Campinas - São Paulo')

    # Act
    login_as(user)
    visit root_path
    click_on 'Aeroporto SP'

    # Assert
    expect(page).not_to have_content('TV32-SAMSU-XPTO90')
  end
end
