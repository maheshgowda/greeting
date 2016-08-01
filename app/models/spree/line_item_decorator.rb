Spree::LineItem.class_eval do
    has_one :greeting, through: :variant
    delegate :name, :description, :sku, :should_track_inventory?, :greeting, to: :variant

end
