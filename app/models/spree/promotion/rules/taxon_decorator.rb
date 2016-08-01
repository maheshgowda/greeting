Spree::Promotion::Rules::Taxon.class_eval do
        
        def actionable?(line_item)
          taxon_product_ids.include? line_item.variant.product_id
          taxon_greeting_ids.include? line_item.variant.greeting_id
        end

        private

        def taxon_greeting_ids
          Spree::Greeting.joins(:taxons).where(spree_taxons: {id: taxons.pluck(:id)}).pluck(:id).uniq
        end
end
