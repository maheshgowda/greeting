Spree::Order.class_eval do
    
    has_many :greetings, through: :variants
end
