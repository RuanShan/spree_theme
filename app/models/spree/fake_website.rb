module Spree
  #it has to be in module Spree, website.template_theme require it. 
  class FakeWebsite < ActiveRecord::Base      
      #self.table_name = 'fake_websites'
      belongs_to :template_theme, :foreign_key=>"theme_id"
      belongs_to :template_release, :foreign_key=>"template_release_id"

      before_validation :set_short_name
      attr_accessible :index_page,:theme_id
      class << self
        
        def dalianshopsdesigns
          find(1)
        end
        
        def current
          if Thread.current[:website].nil?
            website = self.find_or_initialize_by_url_and_name('demo.spreecommerce.com','DalianShops Demo Site' )
            if website.new_record?
              website.theme_id = 1
              website.save!
            end
            Thread.current[:website] = website
          end
          Thread.current[:website]
        end
      end
      
      def set_short_name
        self.short_name = self.name.parameterize
      end
      
      # shop's resource should be in this folder
      def document_root
        File.join(Rails.root,'public') 
      end
      
      def document_path
        self.document_root + self.path
      end
      
      def path
        File.join( File::SEPARATOR + 'shops', Rails.env, self.id.to_s )
      end
      
      def layout
        self.template_release.present? ? self.template_release.layout_path : nil
      end
      
    end
end