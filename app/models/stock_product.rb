class StockProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product_model
  belongs_to :warehouse
end
