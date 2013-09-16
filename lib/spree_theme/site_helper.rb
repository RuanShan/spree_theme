module SpreeTheme
  module SiteHelper
    extend ActiveSupport::Concern
    included do     
      belongs_to :template_theme, :foreign_key=>"theme_id"
      belongs_to :template_release, :foreign_key=>"template_release_id"
      attr_accessible :index_page,:theme_id
    end
    
    module ClassMethods
      def dalianshopsdesigns
        find(1)
      end        
      def current
        if Thread.current[:spree_site].nil?
          website = self.find_or_initialize_by_url_and_name('demo.dalianshops.com','DalianShops Demo Site' )
          if website.new_record?
            website.theme_id = 1
            website.save!
          end
          Thread.current[:spree_site] = website
        end
        Thread.current[:spree_site]
      end
      # shop's resource should be in this folder
      def document_root
        File.join(Rails.root,'public') 
      end
      
      def document_layout_path
        File.join( document_root, 'shops', Rails.env )
      end
    end  

      def document_path
        self.class.document_root + self.path
      end
      
      def path
        File.join( File::SEPARATOR + 'shops', Rails.env, self.id.to_s )
      end
      
      def layout
        self.template_release.present? ? self.template_release.layout_path : nil
      end
      
      
  end
end