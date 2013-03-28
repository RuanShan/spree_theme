=begin
objs=[
  { "is_enabled"=>true, "section_id"=>1, "id"=>1, "root_id"=>1, "parent_id"=>0, "lft"=>1, "rgt"=>10, "section_instance"=>0, "slug"=>"layout1"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>2, "root_id"=>1, "parent_id"=>1, "lft"=>2, "rgt"=>9, "section_instance"=>0, "slug"=>"bd"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>3, "root_id"=>1, "parent_id"=>2, "lft"=>3, "rgt"=>4, "section_instance"=>2, "slug"=>"header"},
  { "is_enabled"=>true, "section_id"=>2, "id"=>4, "root_id"=>1, "parent_id"=>2, "lft"=>5, "rgt"=>8, "section_instance"=>3, "slug"=>"content"},
  { "is_enabled"=>true, "section_id"=>3, "id"=>5, "root_id"=>1, "parent_id"=>4, "lft"=>6, "rgt"=>7, "section_instance"=>0, "slug"=>"menu"}]

  PageLayout.delete_all              
  for ha in objs
    obj = PageLayout.new
    obj.send(:attributes=, ha, false)
    obj.save
  end
=end                

# section slugs= [root,container,menu]
objects = Spree::Section.roots
section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
# puts "section_hash=#{section_hash.keys}"
website_id = section_hash['root'].website_id
  

# center area
center_area = Spree::PageLayout.create_layout(section_hash['center_area'], "center_area")
center_area.add_section(section_hash['center_part'].id,:title=>"center_part")
center_area.add_section(section_hash['left_part'].id,:title=>"left_part")
center_area.add_section(section_hash['right_part'].id,:title=>"right_part")
  
  
  
root = Spree::PageLayout.create_layout(section_hash['root'], "Template One")

header = root.add_section(section_hash['container'].id,:title=>"Header")
header.add_section(section_hash['logo'].id,:title=>"Logo")
header.add_section(section_hash['hmenu'].id,:title=>"Main menu")

body = root.add_section(section_hash['container'].id,:title=>"content")
footer = root.add_section(section_hash['container'].id,:title=>"footer")

lftnav = body.add_section(section_hash['container'].id,:title=>"lftnav")
main_content = body.add_section(section_hash['container'].id,:title=>"main content")

lftnav.add_section(section_hash['vmenu'].id,:title=>"Categories")

blog_list = main_content.add_section(section_hash['container'].id,:title=>"product list")
blog_detail = main_content.add_section(section_hash['container'].id,:title=>"product detail")
blog_list.add_section(section_hash['product-name'].id,:title=>"product name")


blog_detail.add_section(section_hash['product-name'].id,:title=>"product name")
blog_detail.add_section(section_hash['product-description'].id,:title=>"product description")

blog_list.reload   #reload left, right
blog_detail.reload #reload left, right
blog_list.update_section_context( Spree::PageLayout::ContextEnum.list )
blog_list.update_data_source( Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.list].first )

blog_detail.update_section_context( Spree::PageLayout::ContextEnum.detail )
blog_detail.update_data_source( Spree::PageLayout::ContextDataSourceMap[Spree::PageLayout::ContextEnum.detail].first )



footer.add_section(section_hash['hmenu'].id,:title=>"footer menu")
footer.add_section(section_hash['text'].id,:title=>"copyright")
