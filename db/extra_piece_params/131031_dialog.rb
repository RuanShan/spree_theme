
include SpreeTheme::SectionPieceParamHelper

#dialog width, height, 
section_piece = Spree::SectionPiece.find 'dialog-title'

title =  { "editor_id"=>2,  "class_name"=>"title", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"31,32,7,8,6"}
create_section_piece_param( section_piece, title)

title =  { "editor_id"=>3, "class_name"=>"title", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"2,3,4,5"}
create_section_piece_param( section_piece, title)

title =   { "editor_id"=>4,  "class_name"=>"a", "pclass"=>"css", "param_category_id"=>4,  "html_attribute_ids"=>"24,27,49,53,54"}  
create_section_piece_param( section_piece, title)


section_piece = Spree::SectionPiece.find 'dialog-content'
content =  { "editor_id"=>2,  "class_name"=>"inner", "pclass"=>"css", "param_category_id"=>5,  "html_attribute_ids"=>"31,32"}
create_section_piece_param( section_piece, content)
