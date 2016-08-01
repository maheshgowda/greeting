class AddGreetingcardPictureToSpreeGreetings < ActiveRecord::Migration
  def change
    add_attachment :spree_greetings, :greetingcard_picture
  end
end
