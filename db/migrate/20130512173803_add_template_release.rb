class AddTemplateRelease < ActiveRecord::Migration
  def up
    create_table :spree_template_releases do |t|
      t.string :name,:limit => 24,     :null => false
      t.integer :theme_id,     :null => false, :default => 0
      t.timestamps
    end 
    add_column :spree_template_themes, :release_id, :integer, :default => 0
  end

  def down
    drop_table :spree_template_releases
    remove_column :spree_template_themes, :release_id
  end
end
