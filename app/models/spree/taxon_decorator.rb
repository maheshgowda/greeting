Spree::Taxon.class_eval do
    
    has_many :greeting_classifications, -> { order(:position) }, dependent: :delete_all, inverse_of: :taxon
    has_many :greetings, through: :greeting_classifications
   
    def applicable_filter
      fs = []
      # fs << ProductFilters.taxons_below(self)
      ## unless it's a root taxon? left open for demo purposes

      fs << Spree::Core::ProductFilters.price_filter if Spree::Core::ProductFilters.respond_to?(:price_filter)
      fs << Spree::Core::ProductFilters.brand_filter if Spree::Core::ProductFilters.respond_to?(:brand_filter)
      fs
      fss = []
      # fs << GreetingFilters.taxons_below(self)
      ## unless it's a root taxon? left open for demo purposes

      fss << Spree::Core::GreetingFilters.price_filter if Spree::Core::GreetingFilters.respond_to?(:price_filter)
      
      fss
    end

    def active_greetings
      greetings.active
    end

end


