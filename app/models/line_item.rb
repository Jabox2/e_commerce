class LineItem < ActiveRecord::Base
    belongs_to :product
    belongs_to :order
    
    before_save :make_number #to prevent error if addind nothing to cart
    
    private
    def make_number
        if self.quantity == nil then self.quantity = 0 end
    end
end
