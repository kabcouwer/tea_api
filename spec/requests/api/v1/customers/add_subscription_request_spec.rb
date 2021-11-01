require 'rails_helper'

describe 'Customers Adding Subscriptions API' do
  create_factory

  before :each do
    @customer1 = Customer.first
    @tea2 = Tea.second
  end

  describe 'happy paths' do
    it 'add a tea subscription to a customer' do
      title = 'Fall Sale'
      price = '9.99'
      frequency = 'quarterly'

      post "/api/v1/customers/#{@customer1.id}/subscriptions?title=#{title}&price=#{price}&tea_name=#{@tea2.title}&frequency=#{frequency}"

      expect(response.status).to eq(201)

      result = JSON.parse(response.body, symbolize_names: true)

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
      expect(data[:attributes][:title]).to eq(title)

      expect(data[:attributes]).to have_key(:price)
      expect(data[:attributes][:price]).to eq(price.to_f)

      expect(data[:attributes]).to have_key(:status)
      expect(data[:attributes][:status]).to eq('active')

      expect(data[:attributes]).to have_key(:frequency)
      expect(data[:attributes][:frequency]).to eq(frequency)

      expect(data[:attributes]).to have_key(:tea_id)
      expect(data[:attributes][:tea_id]).to eq(@tea2.id)

      expect(data[:attributes]).to have_key(:customer_id)
      expect(data[:attributes][:customer_id]).to eq(@customer1.id)
    end

    describe 'sad paths' do
      it 'returns error if data missing' do
        price = '9.99'
        frequency = 'quarterly'

        post "/api/v1/customers/#{@customer1.id}/subscriptions?price=#{price}&tea_name=#{@tea2.title}&frequency=#{frequency}"

        expect(response.status).to eq(400)
        
        result = JSON.parse(response.body, symbolize_names: true)

        error = result[:errors]

        expect(error).to eq("Title can't be blank")
      end
    end
  end
end
