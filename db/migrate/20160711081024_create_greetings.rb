class CreateGreetings < ActiveRecord::Migration
  def change
    create_table "spree_greetings", force: :cascade do |t|
      t.string   "name",                 limit: 255,   default: "",   null: false
      t.text     "description",          limit: 65535
      t.datetime "available_on"
      t.datetime "deleted_at"
      t.string   "permalink",                 limit: 255
      t.text     "meta_description",     limit: 65535
      t.string   "meta_keywords",        limit: 255
      t.integer  "tax_category_id",      limit: 4
      t.integer  "shipping_category_id", limit: 4
      t.datetime "created_at",                                        null: false
      t.datetime "updated_at",                                        null: false
      t.boolean  "promotionable",                      default: true
      t.string   "meta_title",           limit: 255
    end
    
    add_index :spree_greetings, [:available_on], :name => 'index_spree_greetings_on_available_on'
    add_index :spree_greetings, [:deleted_at],   :name => 'index_spree_greetings_on_deleted_at'
    add_index :spree_greetings, [:name],         :name => 'index_spree_greetings_on_name'
    add_index :spree_greetings, [:permalink],    :name => 'index_spree_greetings_on_permalink'
  end
end
