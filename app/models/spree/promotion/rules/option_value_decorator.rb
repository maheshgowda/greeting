Spree::Promotion::Rules::OptionValue.class_eval do
    
        def actionable?(line_item)
          pid = line_item.product.id
          ovids = line_item.variant.option_values.pluck(:id)

          product_ids.include?(pid) && (value_ids(pid) - ovids).empty?
          
          pid = line_item.greeting.id
          ovids = line_item.variant.option_values.pluck(:id)

          greeting_ids.include?(pid) && (value_ids(pid) - ovids).empty?
        end

        private

        def greeting_ids
          preferred_eligible_values.keys
        end

        def value_ids(product_id)
          preferred_eligible_values[product_id]
        end
end
