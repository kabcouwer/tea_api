class Address < ApplicationRecord
  belongs_to :customer

  validates :number, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
end
