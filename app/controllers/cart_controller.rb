class CartController < ApplicationController
  def add_to_cart
    line_items = LineItem.all
    exists = false
    line_item = nil
    
    #checks if product is already in line items
    line_items.each do |item|
      if item.product_id == params[:product_id].to_i
        exists = true
        line_item = item
      end
    end
    
    if exists == true
      line_item.quantity += params[:quantity].to_i #adds to existing line item quantity
    else
      line_item = LineItem.new() #creates new line item
      line_item.product_id = params[:product_id]
      line_item.quantity = params[:quantity]
    end
    
    line_item.save
    line_item.line_item_total = line_item.product.price * line_item.quantity
    line_item.save
    
    redirect_to root_path
  end

  def view_order
  @line_items = LineItem.all
  end

  def checkout
    @line_items = LineItem.all
    @order = Order.new
    @order.user_id = current_user.id
    @order.subtotal = 0
    
    #sets total quantities for each item in order and sets order.subtotal
    @line_items.each do |line_item|
      if @order.order_items[line_item.product_id].nil?
        @order.order_items[line_item.product_id] = line_item.quantity
      else
        @order.order_items[line_item.product_id] += line_item.quantity
      end
      
      @order.subtotal += line_item.line_item_total
    end
    
    @order.sales_tax = @order.subtotal * 0.08
    @order.grand_total = @order.subtotal + @order.sales_tax
    @order.save
    
    @line_items.each do |line_item|
      line_item.product.quantity -= line_item.quantity
      line_item.product.save
    end
    
    LineItem.destroy_all
  end
end
