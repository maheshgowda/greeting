class RenamePermalinkToSlugForGreetings < ActiveRecord::Migration
  def change
    rename_column :spree_greetings, :permalink, :slug
  end
end
