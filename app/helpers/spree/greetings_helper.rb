module Spree
  module GreetingsHelper
    # returns the formatted price for the specified variant as a full price or a difference depending on configuration
    def variant_price(variant)
      if Spree::Config[:show_variant_full_price]
        variant_full_price(variant)
      else
        variant_price_diff(variant)
      end
    end
	  
	  # returns the formatted price for the specified variant as a difference from greeting price
    def variant_price_diff(variant)
      variant_amount = variant.amount_in(current_currency)
      greeting_amount = variant.greeting.amount_in(current_currency)
      return if variant_amount == greeting_amount || greeting_amount.nil?
      diff   = variant.amount_in(current_currency) - greeting_amount
      amount = Spree::Money.new(diff.abs, currency: current_currency).to_html
      label  = diff > 0 ? :add : :subtract
      "(#{Spree.t(label)}: #{amount})".html_safe
    end

    # returns the formatted full price for the variant, if at least one variant price differs from greeting price
    def variant_full_price(variant)
      greeting = variant.greeting
      unless greeting.variants.active(current_currency).all? { |v| v.price == greeting.price }
        Spree::Money.new(variant.price, { currency: current_currency }).to_html
      end
    end

    # converts line breaks in greeting description into <p> tags (for html display purposes)
    def greeting_description(greeting)
      description = if Spree::Config[:show_raw_greeting_description]
                      greeting.description
                    else
                      greeting.description.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
                    end
      description.blank? ? Spree.t(:greeting_has_no_description) : raw(description)
    end

    def line_item_description_text description_text
      if description_text.present?
        truncate(strip_tags(description_text.gsub('&nbsp;', ' ').squish), length: 100)
      else
        Spree.t(:greeting_has_no_description)
      end
    end

    def cache_key_for_greetings
      count = @greetings.count
      max_updated_at = (@greetings.maximum(:updated_at) || Date.today).to_s(:number)
      greetings_cache_keys = "spree/greetings/all-#{params[:page]}-#{max_updated_at}-#{count}"
      (common_greeting_cache_keys + [greetings_cache_keys]).compact.join("/")
    end

    def cache_key_for_greeting(greeting = @greeting)
      (common_greeting_cache_keys + [greeting.cache_key, greeting.possible_promotions]).compact.join("/")
    end

    def available_status(greeting) # will return a human readable string
      return Spree.t(:discontinued)  if greeting.discontinued?
      return Spree.t(:deleted)  if greeting.deleted?

      if greeting.available?
        Spree.t(:available)
      elsif greeting.available_on && greeting.available_on.future?
        Spree.t(:pending_sale)
      else
        Spree.t(:no_available_date_set)
      end
    end

    private

    def common_greeting_cache_keys
      [I18n.locale, current_currency] + price_options_cache_key
    end

    def price_options_cache_key
      current_price_options.sort.map(&:last).map do |value|
        value.try(:cache_key) || value
      end
    end
  end
end