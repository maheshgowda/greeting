class CreateGreetingsTaxons < ActiveRecord::Migration
  def change
    create_table "spree_greetings_taxons", force: :cascade do |t|
      t.integer "greeting_id"
      t.integer "taxon_id"
      t.integer "position"
    end

  add_index "spree_greetings_taxons", ["position"], name: "index_spree_greetings_taxons_on_position"
  add_index "spree_greetings_taxons", ["greeting_id"], name: "index_spree_greetings_taxons_on_greeting_id"
  add_index "spree_greetings_taxons", ["taxon_id"], name: "index_spree_greetings_taxons_on_taxon_id"

  end
end
