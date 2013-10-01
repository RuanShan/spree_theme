def create_section_piece_param( section_piece, section_piece_param_attrs)
  section_piece.section_piece_params.create! do|spp|
    spp.param_conditions={}
    spp.assign_attributes( section_piece_param_attrs,  :without_protection => true)
  end
end  

section_piece = Spree::SectionPiece.find "product-name"
a =  { "editor_id"=>3,  "class_name"=>"a", "pclass"=>"css", "param_category_id"=>61,  "html_attribute_ids"=>"2,3,4,5"}  
ah =  { "editor_id"=>3,  "class_name"=>"ah", "pclass"=>"css", "param_category_id"=>62,  "html_attribute_ids"=>"2,3,4,5"}  
create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, ah)

a = { "editor_id"=>4,  "class_name"=>"a", "pclass"=>"css", "param_category_id"=>11,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
ah = { "editor_id"=>4,  "class_name"=>"ah", "pclass"=>"css", "param_category_id"=>12,  "html_attribute_ids"=>"23,24,25,27,49,53,54,56"}  
create_section_piece_param( section_piece, a)
create_section_piece_param( section_piece, ah)
