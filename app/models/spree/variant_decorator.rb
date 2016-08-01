Spree::Variant.class_eval do
    acts_as_list scope: :greeting

    include Spree::DefaultPrice

    belongs_to :greeting, class_name: 'Spree::Greeting', inverse_of: :variants
    
    #delegate_belongs_to :greeting, :name, :description, :slug, :available_on,
                       # :shipping_category_id, :meta_description, :meta_keywords,
                       # :shipping_category
    
    delegate_belongs_to :greeting, :name, :description, :slug, :available_on,
                        :meta_description, :meta_keywords

    self.whitelisted_ransackable_associations = %w[option_values product greeting prices default_price]
    self.whitelisted_ransackable_attributes = %w[weight sku]

    def available?
      !discontinued? && (product.available? || greeting.available?)
    end
    
    # Product may be created with deleted_at already set,
    # which would make AR's default finder return nil.
    # This is a stopgap for that little problem.
    def greeting
      Spree::Greeting.unscoped { super }
    end

    def set_option_value(opt_name, opt_value)
      # no option values on master
      return if self.is_master

      option_type = Spree::OptionType.where(name: opt_name).first_or_initialize do |o|
        o.presentation = opt_name
        o.save!
      end

      current_value = self.option_values.detect { |o| o.option_type.name == opt_name }

      unless current_value.nil?
        return if current_value.name == opt_value
        self.option_values.delete(current_value)
      else
        # then we have to check to make sure that the product has the option type
        unless self.product.option_types.include? option_type
          self.product.option_types << option_type
        end
          
		  # then we have to check to make sure that the greeting has the option type
        if self.greeting.option_types.exclude? option_type
          self.greeting.option_types << option_type
        end
      end

      option_value = Spree::OptionValue.where(option_type_id: option_type.id, name: opt_value).first_or_initialize do |o|
        o.presentation = opt_value
        o.save!
      end

      self.option_values << option_value
      self.save
    end

    private

    def set_master_out_of_stock
      if product.master && product.master.in_stock?
        product.master.stock_items.update_all(backorderable: false)
        product.master.stock_items.each(&:reduce_count_on_hand_to_zero)
      end
      #if greeting.master && greeting.master.in_stock?
      #  greeting.master.stock_items.update_all(backorderable: false)
       # greeting.master.stock_items.each(&:reduce_count_on_hand_to_zero) 
      #end
    end

    # Ensures a new variant takes the product master price when price is not supplied
    def check_price
      if price.nil? && Spree::Config[:require_master_price]
        raise 'No master variant found to infer price' unless product && product.master
        raise 'No master variant found to infer price' unless greeting && greeting.master
        raise 'Must supply price for variant or master.price for product.' if self == product.master
        self.price = product.master.price
        raise 'Must supply price for variant or master.price for greeting.' if self == greeting.master
        self.price = greeting.master.price
      end
      if price.present? && currency.nil?
        self.currency = Spree::Config[:currency]
      end
    end

end
