# A rule to limit a promotion based on greetings in the order.
# Can require all or any of the greetings to be present.
# Valid greetings either come from assigned greeting group or are assingned directly to the rule.
module Spree
  class Promotion
    module Rules
      class Greeting < PromotionRule
        has_many :greeting_promotion_rules, class_name: 'Spree::GreetingPromotionRule',
                                           foreign_key: :promotion_rule_id
        has_many :greetings, through: :greeting_promotion_rules, class_name: 'Spree::Greeting'

        MATCH_POLICIES = %w(any all none)
        preference :match_policy, :string, default: MATCH_POLICIES.first

        # scope/association that is used to test eligibility
        def eligible_greetings
          greetings
        end

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          return true if eligible_greetings.empty?

          if preferred_match_policy == 'all'
            unless eligible_greetings.all? {|p| order.greetings.include?(p) }
              eligibility_errors.add(:base, eligibility_error_message(:missing_greeting))
            end
          elsif preferred_match_policy == 'any'
            unless order.greetings.any? {|p| eligible_greetings.include?(p) }
              eligibility_errors.add(:base, eligibility_error_message(:no_applicable_greetings))
            end
          else
            unless order.greetings.none? {|p| eligible_greetings.include?(p) }
              eligibility_errors.add(:base, eligibility_error_message(:has_excluded_greeting))
            end
          end

          eligibility_errors.empty?
        end

        def actionable?(line_item)
          case preferred_match_policy
          when 'any', 'all'
            greeting_ids.include? line_item.variant.greeting_id
          when 'none'
            greeting_ids.exclude? line_item.variant.greeting_id
          else
            raise "unexpected match policy: #{preferred_match_policy.inspect}"
          end
        end

        def greeting_ids_string
          greeting_ids.join(',')
        end

        def greeting_ids_string=(s)
          self.greeting_ids = s.to_s.split(',').map(&:strip)
        end
      end
    end
  end
end
