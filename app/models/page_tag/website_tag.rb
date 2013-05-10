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
      File.join(page_generator.public_path, page_generator.theme.file_name(target))
    end
    
  end
end
