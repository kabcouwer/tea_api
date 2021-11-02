class Api::V1::Customers::SubscriptionsController < ApplicationController
  def create
    unless request.content_type == 'application/json'
      bad_request('Json content type required') and return
    end

    body = JSON.parse(request.raw_post, symbolize_names: true)
    sub = Subscription.create(subscription_params)

    if sub.save
      render json: SubscriptionSerializer.new(sub), status: :created
    else
      bad_request(sub.errors.full_messages.join(', '))
    end
  end

  private
  def subscription_params
    params.permit(:title, :price, :frequency, :tea_id, :customer_id)
  end
end
