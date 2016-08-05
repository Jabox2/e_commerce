class OrdersController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  def new
    @order = create_order
    
    redirect_to orders_path
  end
  
  def select_order
    @user = current_user
    @user.active_order_id = params[:order_id]
    @user.save
    
    redirect_to orders_path
  end

  def show
    render orders_path
  end
  
  def index
    @orders = current_user.orders.all
  end
    
  def edit
  end
    
  def destroy
    order = Order.find(params[:id])
    user = order.user
    
    if order.id == user.active_order_id
      user.active_order_id = nil
      user.save
    end
    order.destroy
    
    redirect_to orders_path
  end
    
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
    
  private
  def set_product
    @order = Order.find(params[:id])
  end
  
  def order_params
      params.require(:order).permit(:subtotal, :sales_tax, :grand_total, :user_id, :order_items, :name)
  end
    
  def create_order
    @user = current_user
    @order = Order.new
    @user.orders << @order
    @order.subtotal = 0
    @order.save
    
    return @order
  end
end