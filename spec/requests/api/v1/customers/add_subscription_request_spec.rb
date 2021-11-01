require 'rails_helper'

describe 'Customers Adding Subscriptions API' do
  create_factory

  before :each do
    @customer1 = Customer.first
  end

  describe 'happy paths' do
    it 'add a tea subscription to a customer' do
      post "/api/v1/customers/#{@customer1.id}/subcriptions"

      expect(response.status).to eq(200)
    end
  end
end
