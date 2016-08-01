Spree::AppConfiguration.class_eval do
   preference :admin_greetings_per_page, :integer, default: 10
   preference :greetings_per_page, :integer, default: 12
   preference :show_greetings_without_price, :boolean, default: false
   preference :show_raw_greeting_description, :boolean, default: false
end