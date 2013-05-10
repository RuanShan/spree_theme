module Spree
  module Admin
    class TemplateThemesController < Spree::Admin::BaseController
      before_filter :load_order, :only => [:edit, :update, :release, :copy_theme]

      #list themes
      def index
        @themes = TemplateTheme.all
      end

      #new theme
      def copy_theme
        
      end
      #publish theme
      def publish
        
        
      end

      begin 'designer'
        def release
          options[:serialize_ehtml] = true
          options[:serialize_ecss] = true
        
          @lg = PageGenerator.builder( theme)
          html, css = @lg.build
          if options[:serialize_ehtml]
            @lg.serialize_page(:ehtml)
          end
          css = @lg.generate_assets
          if options[:serialize_css]      
            @lg.serialize_page(:css)
          end
          return html, css     
        end
      end
      
    end
  end
end
