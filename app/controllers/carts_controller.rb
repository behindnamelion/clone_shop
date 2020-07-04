class CartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @carts = current_user.carts
    @product_price = 0

    @carts.each do |cart|
      @product_price += cart.quantity * cart.pack.price
    end
    # 배송비를 일단 기본 2500원으로 산정합니다.
    @shipping_fee = 2500
    
    @total_price = @product_price + @shipping_fee
  end

  def create
    cart = Cart.new(
      pack_id: params[:pack_id], 
      user: current_user, 
      quantity: params[:quantity]
    )
      
    sample_carts = current_user.carts
    present_cart = sample_carts.find_by(pack_id: params[:pack_id])

    if present_cart.present?
      sum_quantity = present_cart.quantity + params[:quantity].to_i
      result = present_cart.update(quantity: sum_quantity)
    else
      result = cart.save
    end
     
    flash[:notice] = "장바구니에 상품이 담겼습니다.장바구니로 이동하시겠습니까?"
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    cart = Cart.find(params[:id])
  
    cart.destroy
    redirect_back(fallback_location: root_path)
  end
end
