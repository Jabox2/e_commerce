class StorefrontController < ApplicationController
  def all_items
    @products = Product.all
    render :index
  end

  def items_by_category
    @products = Product.order(:category_id)
    render :index
  end

  def items_by_brand
    @products = Product.order(:brand)
    render :index
  end
end
