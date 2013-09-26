require 'spec_helper'
describe Spree::Section do
  let (:section) { Spree::Section.first }
  
  it "has right section params" do
    hmenu = Spree::Section.find('hmenu')    
    section_piece_params = hmenu.self_and_descendants.collect{|section| section.section_piece.section_piece_params}.flatten
    section_params = hmenu.self_and_descendants.collect{|section| section.section_params}.flatten    
    section_params.size.should ==section_piece_params.size
  end
  
  it "destroy a section" do
    section.section_params.size.should be > 0 
    section.destroy    
  end
  
  it "build cart section" do
    cart = Spree::Section.find_by_title('cart')
    html = cart.build_html
    html.should =~/yield/
  end
  
  #TODO
  # test add_section_piece, section_param should be added
end
