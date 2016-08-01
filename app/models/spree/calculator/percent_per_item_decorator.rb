Spree::Calculator::PercentPerItem.class_eval do
    
  private

    # Returns all greetings that match this calculator, but only if the calculator
    # is attached to a promotion. If attached to a ShippingMethod, nil is returned.
    # Copied from per_item.rb
    
    def matching_greetings
      if compute_on_promotion?
        self.calculable.promotion.rules.map do |rule|
          rule.respond_to?(:greetings) ? rule.greetings : []
        end.flatten
      end
    end

    def value_for_line_item(line_item)
      if compute_on_promotion?
        return 0 unless matching_products.blank? or matching_products.include?(line_item.product)
        return 0 unless matching_greetings.blank? or matching_greetings.include?(line_item.greeting)
      end
      ((line_item.price * line_item.quantity) * preferred_percent) / 100
    end


end
