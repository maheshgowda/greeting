module Spree
  class GreetingPromotionRule < Spree::Base
    belongs_to :greeting, class_name: 'Spree::Greeting'
    belongs_to :promotion_rule, class_name: 'Spree::PromotionRule'

    validates :greeting, :promotion_rule, presence: true
    validates :greeting_id, uniqueness: { scope: :promotion_rule_id }, allow_nil: true
  end
end
