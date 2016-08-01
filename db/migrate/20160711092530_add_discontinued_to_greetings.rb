class AddDiscontinuedToGreetings < ActiveRecord::Migration
  def up
        
    add_column :spree_greetings, :discontinue_on, :datetime, after: :available_on
   
    add_index :spree_greetings, :discontinue_on
    
    Spree::Greeting.only_deleted.each do |greeting|
      # determine if there is a slug duplicate
      the_dup = Spree::Greeting.find_by(slug: greeting.slug)
      if the_dup.nil?
        # check to see if there are line items attached to any variants
        if Spree::Variant.with_deleted.where(greeting_id: greeting.id).map(&:line_items).any?
          puts "recovering deleted greeting id #{greeting.id} ... this will un-delete the record and set it to be discontinued"

          old_deleted = greeting.deleted_at
          greeting.update_column(:deleted_at, nil) # for some reason .recover doesn't appear to be a method
          greeting.update_column(:discontinue_on, old_deleted)
        else
          puts "leaving greeting id #{greeting.id} deleted because there are no line items attached to it..."
        end
      else
        puts "leaving greeting id #{greeting.id} deleted because there is a duplicate slug for '#{greeting.slug}' (greeting id #{the_dup.id}) "
        if greeting.variants.map(&:line_items).any?
          puts "WARNING: You may still have bugs with greeting id #{greeting.id} (#{greeting.name}) until you run rake db:fix_orphan_line_items"
        end
      end
    end
  end

  def down
    execute "UPDATE `spree_greetings` SET `deleted_at` = `discontinue_on` WHERE `deleted_at` IS NULL"
    
    remove_column :spree_greetings, :discontinue_on
  end
end
