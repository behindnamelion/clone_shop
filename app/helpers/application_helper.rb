module ApplicationHelper
    def item_to_currency(order_item)
        number_to_currency(order_item.quantity*order_item.pack.price)
    end
    
    
    
end
