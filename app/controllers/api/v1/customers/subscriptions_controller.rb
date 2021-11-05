class Api::V1::Customers::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])
    subs = customer.subscriptions
    render json: SubscriptionSerializer.new(subs)
  end

  def create
    check_headers and return if true

    body = JSON.parse(request.raw_post, symbolize_names: true)
    sub = Subscription.create(
      title: body[:title],
      price: body[:price],
      frequency: body[:frequency],
      tea_id: body[:tea_id],
      customer_id: params[:customer_id]
    )

    if sub.save
      render json: SubscriptionSerializer.new(sub), status: :created
    else
      bad_request(sub.errors.full_messages.join(', '))
    end
  end

  def update
    check_headers and return if true

    body = JSON.parse(request.raw_post, symbolize_names: true)
    sub = Subscription.find(params[:id])

    if sub.update(status: body[:status])
      render json: SubscriptionSerializer.new(sub)
    else
      bad_request('Status Required') and return
    end
  rescue ActiveRecord::RecordNotFound
    not_found
  end

  private
  def subscription_params
  end

  def check_headers
    if request.content_type != 'application/json'
      bad_request('Json content type required')
    end
  end
end
