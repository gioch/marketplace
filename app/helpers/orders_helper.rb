module OrdersHelper
  def show_user_name(order, is_seller)
    is_seller ? order.seller_name : order.buyer_name
  end
end
