class RenameTables < ActiveRecord::Migration
  def up
    rename_table :html_attributes, :spree_html_attributes
    rename_table :section_pieces, :spree_section_pieces
    rename_table :param_categories, :spree_param_categories
    rename_table :editors, :spree_editors
    rename_table :sections, :spree_sections
    rename_table :page_layouts, :spree_page_layouts
    rename_table :section_piece_params, :spree_section_piece_params
    rename_table :section_params, :spree_section_params
    rename_table :section_texts, :spree_section_texts
    rename_table :template_themes, :spree_template_themes
    rename_table :param_values, :spree_param_values
    rename_table :template_files, :spree_template_files
  end

  def down
    
  end
end
