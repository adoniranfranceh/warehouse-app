require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid' do
  	context 'presence' do
	  	it 'false when corporate_name is empty' do
	  	  supplier = Supplier.new(corporate_name: '', brand_name: 'Spark', registration_number: '56144734000107',
	                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
	  	  expect(supplier).not_to be_valid
	  	end

	  	it 'false when brand_name is empty' do
	  		supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: '', registration_number: '56144734000107',
	                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
	  		expect(supplier).not_to be_valid
	  	end

	    it 'false when registration_number is empty' do
	    	supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '',
	                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
	    	expect(supplier).not_to be_valid
	  	end

	  	it 'false when full_address is empty' do
	    	supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
	                  	full_address: '', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
	    	expect(supplier).not_to be_valid
	  	end

	  	it 'false when city is empty' do
	    	supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
	                  	full_address: 'Torre da Indústria, 1', city: '', state: 'PI', email: 'vendedor@gmail.com')
	    	expect(supplier).not_to be_valid
	  	end
	 
	  	it 'false when state is empty' do
	    	supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
	                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: '', email: 'vendedor@gmail.com')
	    	expect(supplier).not_to be_valid
	  	end

	  	it 'false when email is empty' do
	    	supplier = Supplier.new(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
	                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: '')
	    	expect(supplier).not_to be_valid
	  	end
	  end

  	it 'false when registration_number alredy in use' do
  		first_supplier = Supplier.create(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
	                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
  		second_supplier = Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '56144734000107',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@gmail.com')
	  	expect(second_supplier).not_to be_valid
  	end

  	it 'false when email alredy in use' do
  		first_supplier = Supplier.create(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '56144734000107',
	                  	full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'vendedor@gmail.com')
  		second_supplier = Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '24785893000196',
                    full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'vendedor@gmail.com')
	  	expect(second_supplier).not_to be_valid
  	end
  end
end
