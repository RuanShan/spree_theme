module PageTag
  class WebsiteTag < Base
    class_attribute :accessable_attributes
    self.accessable_attributes = [:id,:name]
    delegate *self.accessable_attributes, :to => :website

    def website
      page_generator.theme.website
    end
    
    def get(function_name)
      self.website.send function_name
    end
    
    def public_path(target)      
      page_generator.template_release.file_path(target)       
    end
    
  end
end
