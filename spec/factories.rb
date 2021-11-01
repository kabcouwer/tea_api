def create_factory
  # CUSTOMERS
  let!(:customer1) { create(:customer) }
  let!(:customer2) { create(:customer) }
  let!(:customer3) { create(:customer) }
  let!(:customer4) { create(:customer) }
  let!(:customer5) { create(:customer) }
  let!(:customer6) { create(:customer) }

  # ADDRESSES
  let!(:address1) { create(:address, customer: customer1) }
  let!(:address2) { create(:address, customer: customer2) }
  let!(:address3) { create(:address, customer: customer3) }
  let!(:address4) { create(:address, customer: customer4) }
  let!(:address5) { create(:address, customer: customer5) }
  let!(:address6) { create(:address, customer: customer6) }

  # TEAS
  let!(:tea1) { create(:tea) }
  let!(:tea2) { create(:tea) }
  let!(:tea3) { create(:tea) }
  let!(:tea4) { create(:tea) }
  let!(:tea5) { create(:tea) }
  let!(:tea6) { create(:tea) }

  # SUBSCRIPTIONS
  let!(:subscription1) { create(:subscription, status: :active, frequency: :monthly, customer: customer1, tea: tea1) }
end
