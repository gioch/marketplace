class OrdersController < ApplicationController
  before_action :set_order, only: [:new, :create]
  before_action :set_product, only: [:new, :create]
  before_action :authenticate_user!

  def sales
    @orders = Order.latest_sold_by_user(current_user)
  end

  def purchases
    @orders = Order.latest_bought_by_user(current_user)
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    if create_order && process_payment(@product.price)
      @order.buyer = current_user
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  private
    def set_order
      @order = Order.find(params[:id]) rescue nil
    end

    def set_product
      @product = Product.find(params[:product_id]) rescue nil
    end

    def process_payment(price)
      stripe_client = StripeClient.new(params[:stripeToken])
      stripe_client.charge(price)
    end

    def create_order
      @order = Order.new(order_params)
      @order.product_id = @product.id
      @order.buyer_id  = current_user.id
      @order.seller_id = @product.user_id
      @order.save
    end

    def order_params
      params.require(:order).permit(:address, :city, :state)
    end
end
