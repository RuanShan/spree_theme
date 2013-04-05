require 'spec_helper'
describe Spree::ParamValue do
  it "partial_html" do
    ParamValue.first.partial_html    
  end
  
  it "find within_section&within_editor" do
    param_value = Spree::ParamValue.first
    editor = Spree::Editor.first
    param_values = Spree::ParamValue.within_section( param_value ).within_editor( editor )
  end
  
  
end