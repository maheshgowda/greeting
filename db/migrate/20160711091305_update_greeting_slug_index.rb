class UpdateGreetingSlugIndex < ActiveRecord::Migration
  def change
    remove_index :spree_greetings, :slug if index_exists?(:spree_greetings, :slug)
    add_index :spree_greetings, :slug, unique: true
  end
end
