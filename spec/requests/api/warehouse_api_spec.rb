require 'rails_helper'

describe 'Warehouse API' do
  context 'GET /api/v1/warehouses/1' do
    it 'success' do
      # Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                    description: 'Galpão destinado para cargas internacionais')
      # Act
      get("/api/v1/warehouses/#{warehouse.id}")

      # Assert
      expect(response.status).to eq 200

      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq('Aeroporto SP')
      expect(json_response["code"]).to eq('GRU')

      expect(response.content_type).to include('application/json')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'fail if warehouse not found' do
      # Arrange

      # Act
      get('/api/v1/warehouses/9999999')
      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/warehouses' do
    it 'list all warehouses ordered by name' do
      # Arrange
      Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                        address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
      Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                        address: 'Av Atlantica, 80', cep: '80000-000', description: 'Perto do Aeroporto')
      # Act
      get('/api/v1/warehouses')
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["name"]).to eq 'Maceio'
      expect(json_response[1]["name"]).to eq 'Rio'
    end

    it 'return empty if there is no warehouse' do
      # Arrange

      # Act
      get('/api/v1/warehouses')
      # Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end
  end
end
