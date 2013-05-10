class AddTemplateRelease < ActiveRecord::Migration
  def up
    # fake website for test only, user would change index_page, should store it.
    create_table :spree_template_releases do |t|
      t.string :name,:limit => 24,     :null => false
      t.integer :theme_id,     :null => false, :default => 0
      t.timestamps
    end 
  end

  def down
    drop_table :spree_template_releases
  end
end
