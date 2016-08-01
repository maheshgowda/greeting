Spree::ShippingCategory.class_eval do
    
    has_many :greetings, inverse_of: :shipping_category
    
end
