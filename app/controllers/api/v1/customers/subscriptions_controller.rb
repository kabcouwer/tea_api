class Api::V1::Customers::SubscriptionsController < ApplicationController
  def create
    sub = Subscription.create(
      customer: Customer.find(params[:customer_id]),
      tea: Tea.find_by(title: params[:tea_name]),
      title: params[:title],
      price: params[:price],
      frequency: params[:frequency]
    )

    if sub.save
      render json: SubscriptionSerializer.new(sub), status: :created
    else
      bad_request(sub.errors.full_messages.join(', '))
    end
  end
end
