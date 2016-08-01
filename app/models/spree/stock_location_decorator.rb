Spree::StockLocation.class_eval do

    after_create :create_stock_items, if: :propagate_all_variants?
    
    private
    
      def create_stock_items
        Spree::Variant.includes(:product,:greeting).find_each do |variant|
          propagate_variant(variant)
        end
      end
end
