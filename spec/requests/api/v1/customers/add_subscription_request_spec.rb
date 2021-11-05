require 'rails_helper'

describe 'Customers Adding Subscriptions API' do
  create_factory

  before :each do
    @customer1 = Customer.first
    @customer2 = Customer.second

    @tea2 = Tea.second

    @headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }

    # correct input
    @params1 = {
      title: Faker::Mountain.name,
      price: (Faker::Number.decimal(l_digits: 2)).to_s,
      frequency: 'quarterly',
      customer_id: @customer1.id,
      tea_id: @tea2.id
    }.to_json

    # incorrect input
    @params2 = {
      title: Faker::Mountain.name,
      price: (Faker::Number.decimal(l_digits: 2)).to_s,
      customer_id: @customer1.id,
      tea_id: @tea2.id
    }.to_json

    @params3 = {
      title: Faker::Mountain.name,
      price: (Faker::Number.decimal(l_digits: 2)).to_s,
      frequency: 'quarterly',
      customer_id: @customer2.id,
      tea_id: @tea2.id
    }.to_json
  end

  describe 'happy paths' do
    it 'add a tea subscription to a customer' do
      expect { post "/api/v1/customers/#{@customer1.id}/subscriptions", headers: @headers, params: @params1 }.to change(Subscription, :count).by(+1)

      expect(response.status).to eq(201)

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
      expect(data[:attributes][:status]).to eq('active')

      expect(data[:attributes]).to have_key(:frequency)
      expect(data[:attributes][:frequency]).to eq('quarterly')

      expect(data[:attributes]).to have_key(:tea_id)
      expect(data[:attributes][:tea_id]).to eq(@tea2.id)

      expect(data[:attributes]).to have_key(:customer_id)
      expect(data[:attributes][:customer_id]).to eq(@customer1.id)
    end

    describe 'sad paths' do
      it 'returns error if data missing' do
        expect { post "/api/v1/customers/#{@customer1.id}/subscriptions", headers: @headers, params: @params2 }.to change(Subscription, :count).by(0)

        expect(response.status).to eq(400)

        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:errors]

        expect(error).to eq("Frequency can't be blank")
      end

      it 'returns error if invalid json payload' do
        expect { post "/api/v1/customers/#{@customer1.id}/subscriptions", params: @params1 }.to change(Subscription, :count).by(0)

        expect(response.status).to eq(400)

        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:errors]

        expect(error).to eq('Json content type required')
      end

      it 'returns error if params are sent through uri' do
        expect { post "/api/v1/customers/#{@customer1.id}/subscriptions?title=Test&price=9.99&frequency=monthly&tea_id=#{@tea2.id}", headers: @headers }.to change(Subscription, :count).by(0)

        expect(response.status).to eq(400)

        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:errors]

        expect(error).to eq('Json params input required')
      end

      it 'returns error if customer id is not correct' do
        expect { post "/api/v1/customers/#{@customer1.id}/subscriptions", headers: @headers, params: @params3 }.to change(Subscription, :count).by(0)

        expect(response.status).to eq(400)

        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:errors]

        expect(error).to eq('Subscriptions cannot be made for other customers')
      end
    end
  end
end
