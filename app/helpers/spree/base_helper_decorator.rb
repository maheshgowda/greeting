Spree::BaseHelper.module_eval do
    
    #def display_price(product_or_greeting_or_variant)
    #  product_or_greeting_or_variant.
     #   price_in(current_currency).
     #   display_price_including_vat_for(current_price_options).
     #   to_html
    #end
    
    def meta_data
      object = instance_variable_get('@'+controller_name.singularize)
      meta = {}

      if object.kind_of? ActiveRecord::Base
        meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
        meta[:description] = object.meta_description if object[:meta_description].present?
      end

      if meta[:description].blank? && object.kind_of?(Spree::Product)
        meta[:description] = truncate(strip_tags(object.description), length: 160, separator: ' ')
      end
      
		  if meta[:description].blank? && object.kind_of?(Spree::Greeting)
        meta[:description] = truncate(strip_tags(object.description), length: 160, separator: ' ')
      end
		
      meta.reverse_merge!({
        keywords: current_store.meta_keywords,
        description: current_store.meta_description,
      }) if meta[:keywords].blank? or meta[:description].blank?
      meta
    end

end
