class CreateGreetingsPromotionRules < ActiveRecord::Migration
  def change
    create_table :spree_greetings_promotion_rules, :id => false, :force => true do |t|
      t.references :greeting
      t.references :promotion_rule
    end

    add_index :spree_greetings_promotion_rules, [:greeting_id], :name => 'index_greetings_promotion_rules_on_greeting_id'
    add_index :spree_greetings_promotion_rules, [:promotion_rule_id], :name => 'index_greetings_promotion_rules_on_promotion_rule_id'
  end
end
