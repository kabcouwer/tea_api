require 'rails_helper'

describe 'Customers Subscriptions Index API' do
  create_factory

  before :each do
    @customer1 = Customer.first

    @tea1 = Tea.first
    @tea2 = Tea.third

    @sub1 = Subscription.first
    @sub2 = Subscription.second
    @sub3 = Subscription.third

    @headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'happy paths' do
    it 'returns all customers subscriptions' do
      get "/api/v1/customers/#{@customer1.id}/subscriptions"

      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to be_a(Hash)
      data = result[:data]

      expect(data).to be_an(Array)
      expect(data.length).to eq(2)
      expect(data[0]).to be_a(Hash)

      expect(data[0]).to have_key(:id)
      expect(data[0][:id]).to be_a(String)
      expect(data[0][:id].to_i).to be_an(Integer)

      expect(data[0]).to have_key(:type)
      expect(data[0][:type]).to eq('subscription')

      expect(data[0]).to have_key(:attributes)
      expect(data[0][:attributes]).to be_a(Hash)

      expect(data[0][:attributes]).to have_key(:title)
      expect(data[0][:attributes][:title]).to be_a(String)

      expect(data[0][:attributes]).to have_key(:price)
      expect(data[0][:attributes][:price]).to be_a(Float)

      expect(data[0][:attributes]).to have_key(:status)
      expect(data[0][:attributes][:status]).to eq('active')

      expect(data[0][:attributes]).to have_key(:frequency)
      expect(data[0][:attributes][:frequency]).to eq('monthly')

      expect(data[0][:attributes]).to have_key(:tea_id)
      expect(data[0][:attributes][:tea_id]).to eq(@tea1.id)

      expect(data[0][:attributes]).to have_key(:customer_id)
      expect(data[0][:attributes][:customer_id]).to eq(@customer1.id)
    end
  end
end
