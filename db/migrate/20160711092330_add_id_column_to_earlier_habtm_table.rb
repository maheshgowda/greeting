class AddIdColumnToEarlierHabtmTable < ActiveRecord::Migration
  def change
    add_column :spree_greeting_promotion_rules, :id, :primary_key
  end
end
