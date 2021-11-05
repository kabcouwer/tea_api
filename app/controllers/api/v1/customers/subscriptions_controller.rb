class Api::V1::Customers::SubscriptionsController < ApplicationController
  def index
    customer = Customer.find(params[:customer_id])
    subs = customer.subscriptions
    render json: SubscriptionSerializer.new(subs)
  end

  def create
    check_headers and return if true

    body = JSON.parse(request.raw_post, symbolize_names: true)

    if params[:customer_id].to_i == body[:customer_id]
      sub = Subscription.create(subscription_params)
      if sub.save
        render json: SubscriptionSerializer.new(sub), status: :created
      else
        bad_request(sub.errors.full_messages.join(', '))
      end
    else
      bad_request('Subscriptions cannot be made for other customers')
    end
  rescue JSON::ParserError
    bad_request('Json params input required')
  end

  def update
    check_headers and return if true

    body = JSON.parse(request.raw_post, symbolize_names: true)
    sub = Subscription.find(params[:id])

    if sub.update(status: body[:status])
      render json: SubscriptionSerializer.new(sub)
    else
      bad_request(sub.errors.full_messages.join(', '))
    end
  rescue ActiveRecord::RecordNotFound
    not_found
  rescue JSON::ParserError
    bad_request('Json params input required')
  end

  private
  def subscription_params
    params.require(:subscription).permit(:title, :price, :frequency, :customer_id, :tea_id)
  end

  def check_headers
    if request.content_type != 'application/json'
      bad_request('Json content type required')
    end
  end
end
