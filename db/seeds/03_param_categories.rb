objs=[
  {"id"=>1, "position"=>1, "is_enabled"=>true, "editor_id"=>1, "slug"=>"general_config" },
  {"id"=>2, "position"=>1, "is_enabled"=>true, "editor_id"=>2, "slug"=>"general_position" },
  #{"id"=>3, "position"=>1, "is_enabled"=>true, "editor_id"=>3, "slug"=>"general_background" },
  #{"id"=>4, "position"=>1, "is_enabled"=>true, "editor_id"=>4, "slug"=>"general_text" },

  #{"id"=>6, "position"=>6, "is_enabled"=>true, "editor_id"=>2, "slug"=>"link_position" },
  # a
  {"id"=>11, "position"=>11, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link" },
  {"id"=>12, "position"=>12, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_hover" },
  {"id"=>13, "position"=>13, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_selected" },
  {"id"=>14, "position"=>14, "is_enabled"=>true, "editor_id"=>4, "slug"=>"link_selected_hover" },
  {"id"=>15, "position"=>15, "is_enabled"=>true, "editor_id"=>4, "slug"=>"unclickable_link" },
  
  #product img
  {"id"=>30, "position"=>30, "is_enabled"=>true, "editor_id"=>2, "slug"=>"main_image" },
  {"id"=>31, "position"=>31, "is_enabled"=>true, "editor_id"=>2, "slug"=>"thumb_image" },

  #input
  {"id"=>41, "position"=>41, "is_enabled"=>true, "editor_id"=>0, "slug"=>"input" },
  #{"id"=>61, "position"=>61, "is_enabled"=>true, "editor_id"=>3, "slug"=>"link_background" },
  #{"id"=>62, "position"=>62, "is_enabled"=>true, "editor_id"=>3, "slug"=>"link_hover_background" },
  #{"id"=>63, "position"=>63, "is_enabled"=>true, "editor_id"=>3, "slug"=>"link_selected_background" },
  #{"id"=>64, "position"=>64, "is_enabled"=>true, "editor_id"=>3, "slug"=>"link_selected_hover_background" },
  #{"id"=>65, "position"=>65, "is_enabled"=>true, "editor_id"=>3, "slug"=>"unclickable_link" },
  #table
  {"id"=>80, "position"=>80, "is_enabled"=>true, "editor_id"=>2, "slug"=>"cell" },
  {"id"=>81, "position"=>81, "is_enabled"=>true, "editor_id"=>2, "slug"=>"th" },
  {"id"=>82, "position"=>82, "is_enabled"=>true, "editor_id"=>2, "slug"=>"td" },
  #{"id"=>83, "position"=>83, "is_enabled"=>true, "editor_id"=>4, "slug"=>"th_text" },
  #{"id"=>84, "position"=>84, "is_enabled"=>true, "editor_id"=>4, "slug"=>"td_text" },
  ]

Spree::ParamCategory.delete_all              
for ha in objs
  obj = Spree::ParamCategory.new
  obj.assign_attributes( ha,  :without_protection => true)
  obj.editor_id=0
  obj.save
end
                
