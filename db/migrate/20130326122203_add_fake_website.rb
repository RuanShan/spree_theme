class AddFakeWebsite < ActiveRecord::Migration
  def up
    # fake website for test only, user would change index_page, should store it.
    create_table :spree_fake_websites do |t|
      t.string :name,:limit => 24,     :null => false
      t.string :url,:limit => 24
      t.string :short_name,:limit => 24,     :null => false
      t.integer :index_page,     :null => false, :default => 0
      t.integer :theme_id,     :null => false, :default => 0
    end 
  end

  def down
    drop_table :spree_fake_websites
  end
end
