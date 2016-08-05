class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #requires log in
  before_action :authenticate_user!, :except => [:all_items, :items_by_category, :items_by_brand]#enables browsing without login
  
  before_action :categories, :brands
  
  def categories
    @categories = Category.all
  end
  
  def brands
    if (@brands = Product.pluck(:brand).sort.uniq!) == nil
      @brands = Product.pluck(:brand).sort
    end
  end
  
  private 
  def admin_authorize
    unless current_user != nil && current_user.role == "admin"
      flash[:alert] = "You are not signed in as an admin"
      redirect_to root_path
    end
  end
end
