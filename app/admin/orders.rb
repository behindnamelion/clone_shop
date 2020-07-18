ActiveAdmin.register Order do

  scope :all
  scope -> { "결제 전" }, :before_payment
  scope -> { "배송 중" }, :processed
  scope -> { "배송 완료" }, :completed
  scope -> { "결제 취소" }, :failed
  
  filter :name
  filter :phone
  filter :post_code
  filter :address
  filter :email
  filter :user_email_cont, label: "사용자 이메일 포함된 문구"
  filter :packs_product_name_cont, label: "팩의 상품명"
  
  index do
    selectable_column
    id_column
  	column :user do |order|
  		a order.user.email, href: "/admin/users/#{order.user.id}"
  	end
    column :address
    column :email
    column :name
    column :phone
    column :post_code
    column :status
    column :created_at
    actions
  end
  
  
  # show 수정하는 부분
  show do
    attributes_table do
      row :address
      row :email
      row :name
      row :phone
      row :post_code
      row :status
    end
    
    panel "주문한 팩" do
      table_for order.order_items do
        column "팩 이름" do |item|
          item.pack.product_name
        end
        column "양" do |item|
          item.quantity
        end
  			column "가격" do |item|
          number_to_currency(item.quantity * item.pack.price)
        end
        column "링크" do |item|
          a "이동", href: "/admin/packs/#{item.id}", target: "_blank"
        end
      end
    end
  end

  sidebar "Details", only: :show do
    attributes_table_for order.payment do
      row :amount do |payment|
        number_to_currency(payment.amount)
      end
      row :imp_uid
      row :merchant_uid
      row :link do |payment|
        a "iamport 대시보드 이동", href: payment.response["receipt_url"], target: "_blank"
      end
    end
  end

  batch_action "cancelled", form: {
    cancel_reason: :text
  } do |ids, inputs|
    @orders = Order.where(id: ids)
    
    @orders.each do |order|
      iamport = Iamport.payment(params[:imp_uid])
  
      body = {
        imp_uid: order.payment.imp_uid,
        merchant_uid: order.payment.merchant_uid,
        amount: order.payment.amount,
      }
      
      result = Iamport.cancel(body)
  
      if result["response"]["status"] == "cancelled"
        order.update(
          cancel_reason: inputs[:cancel_reason],
          status: :canceled
        )
        flash[:notice] = "성공적으로 환불되었습니다!"
      end
    end
  
    redirect_to collection_path
  end

end
