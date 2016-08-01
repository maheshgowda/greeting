Spree::Promotion.class_eval do
    
    # called anytime order.update_with_updater! happens
    def eligible?(promotable)
      return false if expired? || usage_limit_exceeded?(promotable) || blacklisted?(promotable) || blacklisteds?(promotable)
      !!eligible_rules(promotable, {})
    end

    def greetings
      rules.where(type: "Spree::Promotion::Rules::Greeting").map(&:greetings).flatten.uniq
    end

    private
  

    def blacklisteds?(promotable)
      case promotable
      when Spree::LineItem
        !promotable.greeting.promotionable?
      when Spree::Order
        promotable.line_items.any? &&
          !promotable.line_items.joins(:greeting).where(spree_greetings: {promotionable: true}).any?
      end
    end

end
