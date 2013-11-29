class AddTaxonMtype < ActiveRecord::Migration
  def up
    add_column :spree_taxons, :mtype, :integer, :default => 0
    # 1:home, 2:cart, 3:checkout, 4:thanks, 5:sign in, 6:login, 7:my account, 
  end

  def down
    remove_column :spree_taxons, :mtype      
  end
end
