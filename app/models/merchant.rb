class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions
  validates :name, presence: true
end
