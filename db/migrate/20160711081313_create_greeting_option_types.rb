class CreateGreetingOptionTypes < ActiveRecord::Migration
  def change
    create_table "spree_greeting_option_types", force: :cascade do |t|
      t.integer  "position"
      t.integer  "greeting_id"
      t.integer  "option_type_id"
      t.datetime "created_at",     null: false
      t.datetime "updated_at",     null: false
    end

  add_index "spree_greeting_option_types", ["option_type_id"], name: "index_spree_greeting_option_types_on_option_type_id"
  add_index "spree_greeting_option_types", ["position"], name: "index_spree_greeting_option_types_on_position"
  add_index "spree_greeting_option_types", ["greeting_id"], name: "index_spree_greeting_option_types_on_greeting_id"

  end
end
