class UpdateGreetingClassificationsPositions < ActiveRecord::Migration
  def up
    Spree::Taxon.all.each do |taxon|
      taxon.greeting_classifications.each_with_index do |c12n, i|
        c12n.set_list_position(i + 1)
      end
    end
  end
end
