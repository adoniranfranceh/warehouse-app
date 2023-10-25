class Warehouse < ApplicationRecord
  validates :name, :description, :code, :address, :city, :cep, :area, presence: true
  validates :code, uniqueness: true

  def full_description
    "#{code} - #{name}"
  end
end
