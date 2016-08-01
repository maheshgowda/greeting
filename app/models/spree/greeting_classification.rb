
module Spree
  class GreetingClassification < Spree::Base
    self.table_name = 'spree_greetings_taxons'
    acts_as_list scope: :taxon

    with_options inverse_of: :greeting_classifications, touch: true do
      belongs_to :taxon, class_name: "Spree::Taxon"
      belongs_to :greeting, class_name: "Spree::Greeting"
    end

    
    # For #3494
    validates :taxon_id, uniqueness: { scope: :greeting_id, message: :already_linked, allow_blank: true }
  end
end