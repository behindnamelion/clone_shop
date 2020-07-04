class OrdersController < ApplicationController
  def create
    order = Order.create(user: current_user)
    carts = Cart.where(id: params[:cart_id])
  
    carts.each do |cart|
      order.order_items.create(pack: cart.pack, quantity: cart.quantity)
    end
  
    carts.destroy_all # 추가
  
  	redirect_to "/orders/#{order.id}"
  end

  def show
    @order = Order.find(params[:id])
  end
  
end
