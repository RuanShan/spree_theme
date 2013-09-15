module SpreeTheme
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_theme'

    config.autoload_paths += %W(#{config.root}/lib)
    #rails layout path is fixed view_path/layouts,  so we need to add more view path for SpreeTheme templates
    config.paths['app/views'] << File.join( "public","shops",Rails.env )
    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree.theme.environment", :before => "spree.environment" do |app|
      SpreeTheme = Spree::ThemeConfiguration.new
    end
    
    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
