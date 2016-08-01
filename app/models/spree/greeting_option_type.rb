module Spree
  class GreetingOptionType < Spree::Base
    with_options inverse_of: :greeting_option_types do
      belongs_to :greeting, class_name: 'Spree::Greeting'
      belongs_to :option_type, class_name: 'Spree::OptionType'
    end
    acts_as_list scope: :greeting

    validates :greeting, :option_type, presence: true
    validates :greeting_id, uniqueness: { scope: :option_type_id }, allow_nil: true
  end
end
