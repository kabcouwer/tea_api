require 'rails_helper'

describe 'Customers Cancelling Subscriptions API' do
  create_factory

  before :each do
    @customer1 = Customer.first

    @tea2 = Tea.second

    @subscription1 = Subscription.create(
      title: 'Fall Sale',
      price: '9.99',
      frequency: 'bimonthly',
      tea: @tea2,
      customer: @customer1
    )

    @headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }

    # correct input
    @params1 = {
      status: 'cancelled'
    }.to_json

    # incorrect input
    @params2 = {}.to_json
  end

  describe 'happy paths' do
    it 'cancels a tea subscription to a customer' do
      expect { patch "/api/v1/customers/#{@customer1.id}/subscriptions/#{@subscription1.id}", headers: @headers, params: @params1 }.to change(Subscription, :count).by(0)

      expect(response.status).to eq(200)

      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to be_a(Hash)
      data = result[:data]
      expect(data).to be_a(Hash)

      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)
      expect(data[:id].to_i).to be_an(Integer)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq('subscription')

      expect(data).to be_a(Hash)
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a(Hash)

      expect(data[:attributes]).to have_key(:title)
      expect(data[:attributes][:title]).to be_a(String)

      expect(data[:attributes]).to have_key(:price)
      expect(data[:attributes][:price]).to be_a(Float)

      expect(data[:attributes]).to have_key(:status)
      expect(data[:attributes][:status]).to eq('cancelled')

      expect(data[:attributes]).to have_key(:frequency)
      expect(data[:attributes][:frequency]).to eq('bimonthly')

      expect(data[:attributes]).to have_key(:tea_id)
      expect(data[:attributes][:tea_id]).to eq(@tea2.id)

      expect(data[:attributes]).to have_key(:customer_id)
      expect(data[:attributes][:customer_id]).to eq(@customer1.id)
    end

    describe 'sad paths' do
      it 'returns error if data missing' do
        expect { patch "/api/v1/customers/#{@customer1.id}/subscriptions/#{@subscription1.id}", headers: @headers, params: @params2 }.to change(Subscription, :count).by(0)

        expect(response.status).to eq(400)

        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:errors]

        expect(error).to eq('Status Required')
      end

      it 'returns error if invalid json payload' do
        expect { patch "/api/v1/customers/#{@customer1.id}/subscriptions/#{@subscription1.id}", params: @params1 }.to change(Subscription, :count).by(0)

        expect(response.status).to eq(400)

        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:errors]

        expect(error).to eq('Json content type required')
      end

      it 'returns error if invalid subscription id' do
        expect { patch "/api/v1/customers/#{@customer1.id}/subscriptions/10005", headers: @headers, params: @params1 }.to change(Subscription, :count).by(0)

        expect(response.status).to eq(404)
        
        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:error]

        expect(error).to eq('Not Found')
      end
    end
  end
end
