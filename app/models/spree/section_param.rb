module Spree
  class SectionParam < ActiveRecord::Base  
    has_one :default_param_value, :conditions=>["theme_id=?",0]
    belongs_to :section_piece_param
    belongs_to :section
    serialize :default_value, Hash
    
    after_create :add_param_values

    def disabled_html_attribute_ids
      if @disabled_html_attribute_ids.nil?
        @disabled_html_attribute_ids = self.disabled_ha_ids.split(',').collect{|i|i.to_i}
      end
      @disabled_html_attribute_ids
    end
    
    
    #filter:  :all, :disabled, :enabled
    def html_attributes(attribute_filter= :enabled)
      if @html_attributes.nil?
        ha_ids = self.section_piece_param.html_attribute_ids.split(',').collect{|i|i.to_i}
        @html_attributes= HtmlAttribute.find_by_ids(ha_ids)
      end
  
      case attribute_filter
      when :enabled
        return_html_attributes = @html_attributes.select{|ha| !disabled_html_attribute_ids.include?(ha.id)}
      when :disabled
        return_html_attributes = @html_attributes.select{|ha| disabled_html_attribute_ids.include?(ha.id)}      
      else
        return_html_attributes = @html_attributes
      end
      
    end
    
    private
    #add param_value where page_layout.section_id = ? for each layout tree.
    def add_param_values    
Rails.logger.debug "yes, begin calling after create :add_param_values"        
      page_layouts = PageLayout.includes(:themes).where("section_id"=>self.section.root_id)
      for page_layout in page_layouts
        for theme in page_layout.themes
            page_layout.param_values.create do|param_value|
              param_value.theme_id = theme.id
              param_value.page_layout_root_id = page_layout.root_id              
              param_value.section_param_id = self.id
            end
        end
      end
Rails.logger.debug "yes, end"        
    end
    
    
  end
  
end