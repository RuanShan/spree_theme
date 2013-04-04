require 'spec_helper'
describe Spree::TemplateTheme do
  let (:template) { Spree::TemplateTheme.first }
  it "could serialize&unserialize" do
    serializable_data = template.serializable_data    
    expect(serializable_data).to be_an_instance_of(Hash)
    
    temp_file = Tempfile.new ['theme', '.yml'], File.join( Rails.root, 'tmp')
    
    temp_file.write( serializable_data.to_yaml )
    temp_file.size.should be > 0 #cause flush
    File.exists?(temp_file.path).should be_true
    temp_file.rewind
Rails.logger.debug "temp_file=#{temp_file.size}"    
    Spree::TemplateTheme.import(temp_file)
    
    temp_file.close    
  end

  it "create plain template" do
    section = Spree::Section.find('root')
    template = Spree::TemplateTheme.create_plain_template(section,'Template One')
    
    template.should be_an_instance_of(Spree::TemplateTheme)
    template.page_layout.should be_an_instance_of(Spree::PageLayout)
    template.page_layout.root?.should be_true
    template.param_values.count.should be > 0
    
    first_param_value = template.param_values.first 
    first_param_value.page_layout_id.should eq(template.page_layout.id)
    first_param_value.page_layout_root_id.should eq(template.page_layout.root_id)
    
  end
end