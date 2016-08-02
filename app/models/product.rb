class Product < ActiveRecord::Base
    has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
    belongs_to :category
    
    before_validation :price_to_currency
    
    private
    def price_to_currency
        self.price = self.price.round(2)
    end
end
