class StorefrontController < ApplicationController
  def all_items
    @head = "All Items"
    @products = Product.all
    render :index
  end

  def items_by_category
    @head = Category.find(params[:cat_id]).name
    @products = Product.select{ |product| product.category.id == params[:cat_id].to_i }
    
    render :index
  end

  def items_by_brand
    @head  = params[:brand_id]
    @products = Product.select{|prod| prod.brand == params[:brand_id] }
    render :index
  end
end
