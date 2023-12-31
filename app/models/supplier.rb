class Supplier < ApplicationRecord
  validates :corporate_name, :brand_name, :full_address, :registration_number, :city, :state, :email, presence: true
  validates :registration_number, :email, uniqueness: true
  has_many :product_models

  def description
    "#{corporate_name} - #{registration_number}"
  end
end
