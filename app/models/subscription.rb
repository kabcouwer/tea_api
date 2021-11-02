class Subscription < ApplicationRecord
  enum status: { active: 0, cancelled: 1 }
  enum frequency: { bimonthly: 0, monthly: 1, quarterly: 2 }

  belongs_to :tea
  belongs_to :customer

  validates :title, presence: true
  validates :price, presence: true
  validates :price, numericality: true
  validates :status, presence: true
  validates :frequency, presence: true
end
