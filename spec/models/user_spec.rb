require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#description' do
    it 'exibe o nome e o email do usuário' do
      user = User.new(name: 'Adoniran', email: 'adoniran@gmail.com')

      result = user.description

      expect(result).to eq 'Adoniran - adoniran@gmail.com'
    end
  end
end
