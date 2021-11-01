require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'relationships' do
    it { should belong_to(:tea) }
    it { should belong_to(:customer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }

    statuses = { active: 0, cancelled: 1 }
    it { should define_enum_for(:status).with(statuses) }
    it { should validate_presence_of(:status) }

    frequencies = { bimonthly: 0, monthly: 1, quarterly: 2 }
    it { should define_enum_for(:frequency).with(frequencies) }
    it { should validate_presence_of(:frequency) }
  end
end
