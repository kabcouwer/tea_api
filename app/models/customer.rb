class Customer < ApplicationRecord
  has_one :address
  has_many :subscriptions
  has_many :teas, through: :subscriptions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
