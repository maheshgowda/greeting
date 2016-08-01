class CopyGreetingSlugsToSlugHistory < ActiveRecord::Migration
  def change
    
    # do what sql does best: copy all slugs into history table in a single query
	# rather than load potentially millions of greetings into memory
	Spree::Greeting.connection.execute <<-SQL
    INSERT INTO #{FriendlyId::Slug.table_name} (slug, sluggable_id, sluggable_type, created_at)
      SELECT slug, id, '#{Spree::Greeting.to_s}', #{ActiveRecord::Base.send(:sanitize_sql_array, ['?', Time.current])} 
      FROM #{Spree::Greeting.table_name}
      WHERE slug IS NOT NULL
      ORDER BY id
    SQL

  end
end
