require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        warehouse = Warehouse.new(name: '', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                                 address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
        expect(warehouse).not_to be_valid
      end

      it 'false when code is empty' do
        warehouse = Warehouse.new(name: 'Rio', code: '', city: 'Rio de Janeiro', area: 60_000,
                                 address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
        expect(warehouse.valid?).to be_falsey
      end

      it 'false when city is empty' do
        warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: '', area: 60_000,
                                 address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
        expect(warehouse.valid?).to eq false
      end

      it 'false when area is empty' do
        warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: '',
                                 address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
        expect(warehouse.valid?).to eq false
      end

      it 'false when address is empty' do
        warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                                 address: '', cep: '20000-000', description: 'Galpão do Rio')
        expect(warehouse.valid?).to eq false
      end

      it 'false when cep is empty' do
        warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                                 address: 'Av do  Porto, 1000', cep: '', description: 'Galpão do Rio')
        expect(warehouse.valid?).to eq false
      end

      it 'false when description is empty' do
        warehouse = Warehouse.new(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                                 address: 'Av do  Porto, 1000', cep: '20000-000', description: '')
        expect(warehouse.valid?).to eq false
      end
    end

    it 'false when code already in use' do
      # Arrange
      first_warehouse =  Warehouse.create(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                            address: 'Av do  Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
      second_warehouse = Warehouse.create(name: 'Maceio', code: 'SDU', city: 'Maceio', area: 50_000,
                    address: 'Av Atlantica, 80', cep: '80000-000', description: 'Perto do Aeroporto')

      # Act
      result = second_warehouse.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
