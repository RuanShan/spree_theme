objs=[
  {"id"=>1, "position"=>1, "is_enabled"=>true, "editor_id"=>1, "slug"=>"general_config" },
  {"id"=>2, "position"=>1, "is_enabled"=>true, "editor_id"=>2, "slug"=>"general_position" },
  #{"id"=>3, "position"=>1, "is_enabled"=>true, "editor_id"=>3, "slug"=>"general_background" },
  #{"id"=>4, "position"=>1, "is_enabled"=>true, "editor_id"=>4, "slug"=>"general_text" },

  {"id"=>6, "position"=>6, "is_enabled"=>true, "editor_id"=>0, "slug"=>"title" },
  # a
  {"id"=>11, "position"=>11, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link" },
  {"id"=>12, "position"=>12, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_hover" },
  {"id"=>13, "position"=>13, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_selected" },
  {"id"=>14, "position"=>14, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_selected_hover" },
  {"id"=>15, "position"=>15, "is_enabled"=>true, "editor_id"=>4, "slug"=>"unclickable_link" },
  
  #product img
  {"id"=>30, "position"=>30, "is_enabled"=>true, "editor_id"=>2, "slug"=>"main_image" },
  {"id"=>31, "position"=>31, "is_enabled"=>true, "editor_id"=>2, "slug"=>"thumb_image" },

  #form
  {"id"=>39, "position"=>39, "is_enabled"=>true, "editor_id"=>0, "slug"=>"form" },
  {"id"=>40, "position"=>40, "is_enabled"=>true, "editor_id"=>0, "slug"=>"form_title" },
  {"id"=>42, "position"=>42, "is_enabled"=>true, "editor_id"=>0, "slug"=>"label_name" },
  {"id"=>43, "position"=>43, "is_enabled"=>true, "editor_id"=>0, "slug"=>"label_error" },
  {"id"=>44, "position"=>44, "is_enabled"=>true, "editor_id"=>0, "slug"=>"input" },
   
  {"id"=>45, "position"=>45, "is_enabled"=>true, "editor_id"=>0, "slug"=>"button" },
  #{"id"=>64, "position"=>64, "is_enabled"=>true, "editor_id"=>3, "slug"=>"link_selected_hover_background" },
  #{"id"=>65, "position"=>65, "is_enabled"=>true, "editor_id"=>3, "slug"=>"unclickable_link" },
  #table
  {"id"=>78, "position"=>78, "is_enabled"=>true, "editor_id"=>0, "slug"=>"table" },
  {"id"=>79, "position"=>79, "is_enabled"=>true, "editor_id"=>0, "slug"=>"table_title" },
  {"id"=>80, "position"=>80, "is_enabled"=>true, "editor_id"=>2, "slug"=>"cell" },
  {"id"=>81, "position"=>81, "is_enabled"=>true, "editor_id"=>2, "slug"=>"th" },
  {"id"=>82, "position"=>82, "is_enabled"=>true, "editor_id"=>2, "slug"=>"td" },
  #{"id"=>84, "position"=>84, "is_enabled"=>true, "editor_id"=>4, "slug"=>"td_text" },
  ]

Spree::ParamCategory.delete_all              
for ha in objs
  obj = Spree::ParamCategory.new
  obj.assign_attributes( ha,  :without_protection => true)
  obj.editor_id=0
  obj.save
end
                
