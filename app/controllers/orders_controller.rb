class OrdersController < ApplicationController
    before_action :set_product, only: [:show, :edit, :update, :destroy]
    def show
        @orders = current_user.orders.all
    end
    
    def edit
    end
    
    def destroy
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
end
