class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #requires log in
  before_action :authenticate_user!, :except => [:add_to_cart, :view_order, #enables cart without login
  :all_items, :items_by_category, :items_by_brand]#enables browsing without login
  
  before_action :categories, :brands
  
  def categories
    @categories = Category.all
  end
  
  def brands
    if (@brands = Product.pluck(:brand).sort.uniq!) == nil
      @brands = Product.pluck(:brand).sort
    end
  end
end
