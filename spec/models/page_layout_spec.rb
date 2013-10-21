#page_layout.templates
require 'spec_helper'
describe Spree::PageLayout do
  let (:page_layout) { Spree::PageLayout.first }
  
  it "build html css js" do
    html, css = page_layout.build_content    
    html.present?.should be_true
    css.present?.should be_true
  end
  
  it "create new page_layout tree" do
  #  objects = Spree::Section.roots
  #  section_hash= objects.inject({}){|h,sp| h[sp.slug] = sp; h}
    # center area
  #  center_area = Spree::PageLayout.create_layout(section_hash['center_area'], "center_area")
  #  center_area.add_section(section_hash['center_part'],:title=>"center_part")
  #  center_area.add_section(section_hash['left_part'],:title=>"left_part")
  #  center_area.add_section(section_hash['right_part'],:title=>"right_part")

  #  center_area.children.count.should eq(3)          
  #  center_area.param_values.count.should eq(0)
    
  end
  
  it "valid section context" do
    
    product_detail = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.detail)
    product_detail.context_detail?.should be_true
    product_list = Spree::PageLayout.find_by_section_context( Spree::PageLayout::ContextEnum.list)
    product_list.context_list?.should be_true
  end

  it "could update context" do
    contexts = [Spree::PageLayout::ContextEnum.account, Spree::PageLayout::ContextEnum.thanks,Spree::PageLayout::ContextEnum.cart, Spree::PageLayout::ContextEnum.checkout]
    page_layout.update_section_context contexts
    
    
    for node in page_layout.self_and_descendants
      node.current_contexts.should eq(contexts)
    end
  end

  it "could verify contexts" do
    Spree::PageLayout.verify_contexts( Spree::PageLayout::ContextEnum.cart, [:cart, :checkout, :thankyou ] ).should be_true
    
    Spree::PageLayout.verify_contexts( [Spree::PageLayout::ContextEnum.cart], [:cart, :checkout, :thankyou ] ).should be_true

    Spree::PageLayout.verify_contexts( Spree::PageLayout::ContextEnum.either, [:cart, :checkout, :thankyou ] ).should be_false
  end
  
end