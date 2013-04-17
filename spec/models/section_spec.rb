
require 'spec_helper'
describe Spree::Section do
  let (:section) { Spree::Section.first }
  it "destroy a section" do

    section.section_params.size.should be > 0 
    section.destroy
    
  end
  
  it "build cart section" do
    cart = Spree::Section.find_by_title('cart')
    html = cart.build_html
    html.should =~/yield/
  end
  
end