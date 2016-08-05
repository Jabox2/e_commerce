class CartController < ApplicationController
  def add_to_cart
    @order = set_order
    
    line_items = @order.line_items
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
      @order.line_items << line_item
      @order.save
      line_item.product_id = params[:product_id]
      line_item.quantity = params[:quantity]
    end
    
    line_item.save
    line_item.line_item_total = line_item.product.price * line_item.quantity
    line_item.save
    
    if params[:to_view]
      redirect_to :view_order
    else
      redirect_to root_path
    end
  end
  
  def remove_from_cart
    user = current_user
    order = set_order
    line_item = LineItem.find(params[:line_item_id])
    line_item.quantity -= params[:quantity].to_i
    line_item.save
    
    if line_item.quantity <= 0
      line_item.destroy
    end
    order.save
    user.save
    
    redirect_to :view_order
  end

  def view_order
    @order = set_order
    
    @order = Order.find(current_user.active_order_id)
    @line_items = @order.line_items
  end

  def checkout
    @order = Order.find(current_user.active_order_id)
    @line_items = @order.line_items
    
    if @line_items.empty?
      flash[:alert] = "Order is empty"
      redirect_to root_path
    else
    
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
    
    if out_of_stock #returns true if order can be filled
      @line_items.each do |line_item|
      #to prevent overselling an item
        line_item.product.quantity -= line_item.quantity
        line_item.product.save
      end

      @order.line_items.destroy_all
      @order.save
      
      user = current_user
      user.active_order_id = nil
      user.save
    else #what to do if item is out of stock
      messages = ''
      first = true
      @out_of_stock.each do |product_id, short|
        product = Product.find(product_id)
        if first
          messages = "We are short #{short} #{product.name}"
          first = false
        else
          messages += ", and #{short} #{product.name}"
        end
      end
      messages += " for your order."
      
      flash[:alert] = messages
      redirect_to :view_order
    end
  end
  end
  
  private
  def out_of_stock
    @order = Order.find(current_user.active_order_id)
    line_items = @order.line_items
    @out_of_stock = {}
    @fill_order = true
    
    line_items.each do |line_item|
      if (line_item.product.quantity - line_item.quantity) < 0
        @out_of_stock[line_item.product_id] = line_item.quantity - line_item.product.quantity
        @fill_order = false
      end
    end
      
    return @fill_order
  end
  
  def set_order
    if current_user.active_order_id == nil
      user = current_user
      if user.orders.empty?
        order = Order.new
        user.orders << order
        user.active_order_id = order.id
      else
        user.active_order_id = user.orders.first
      end
      user.save
    else
      order = Order.find(current_user.active_order_id)
    end
    
    return order
  end
end
