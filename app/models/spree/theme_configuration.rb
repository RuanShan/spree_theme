# I have to create own configuration class,  
# because that app_configuration_decorator is loaded after initialize,
# so in config/initializers/spree.rb, could not get seed_dir
# this new class would work 
module Spree
  class ThemeConfiguration < Preferences::Configuration
    #description start with global means it is for whole application, not just one site 
    def website_class
      SampleWebsite
    end
    def taxonomy_class
      Spree::Taxonomy      
    end
    
    class SampleWebsite
      attr_accessor :id, :url, :name, :index_page
      class << self
        def current
          if Thread.current[:website].nil?
            website = SampleWebsite.new
            website.id = 1
            website.name = 'DalianShops Demo Site'
            website.url = 'demo.spreecommerce.com'
            Thread.current[:website] = website
          end
          Thread.current[:website]
        end
      end
    end
  end
end
