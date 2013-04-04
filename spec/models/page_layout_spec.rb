#page_layout.templates
require 'spec_helper'
describe Spree::PageLayout do
  let (:page_layout) { Spree::PageLayout.first }
  it "create new page_layout tree" do
    objects = Spree::Section.roots
    section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
    # center area
    center_area = Spree::PageLayout.create_layout(section_hash['center_area'], "center_area")
    center_area.add_section(section_hash['center_part'].id,:title=>"center_part")
    center_area.add_section(section_hash['left_part'].id,:title=>"left_part")
    center_area.add_section(section_hash['right_part'].id,:title=>"right_part")

    center_area.children.count.should eq(3)          
    center_area.param_values.count.should eq(0)
    
  end
end