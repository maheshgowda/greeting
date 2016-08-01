Spree::OptionType.class_eval do
    
    has_many :greeting_option_types, dependent: :destroy, inverse_of: :option_type
    
    has_many :greetings, through: :greeting_option_types

    after_touch :touch_all_greetings

    private

    def touch_all_greetings
      greetings.update_all(updated_at: Time.current)
    end
  
end
