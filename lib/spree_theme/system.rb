require 'spree/core/controller_helpers/common'
class << Spree::Core::ControllerHelpers::Common  
  def included_with_theme_support(receiver)
    included_without_theme_support(receiver)
    receiver.send :include, SpreeTheme::System
    receiver.send :layout, :get_theme_layout
    receiver.send :before_filter, :initialize_template
  end
  alias_method_chain :included, :theme_support   
end

module SpreeTheme::System
  private
  #override spree's
  def get_theme_layout
    final_layout = Spree::Config[:layout]
    if self.class.to_s.deconstantize=='Spree'      
      if Rails.env !~ /prduction/
        # for development or test, enable get site from cookies
        if cookies[:abc_development_theme].present?
          final_layout = cookies[:abc_development_theme]
        end     
      end
    end
    final_layout
  end

  def initialize_template
      website = SpreeTheme::Config.website_class.current
      if params[:c]
        @menu = taxon_class.find_by_id(params[:c])
        if params[:r]
          @resource = Spree::Product.find_by_id(params[:r])
        end  
      elsif params[:controller]=~/cart|checkout|order/
        @menu = DefaultTaxon.instance
        @menu[:page_type] = 'cart'
      else
        @menu = taxon_class.find_by_id(website.index_page)  
      end
      @theme = Spree::TemplateTheme.find( website.theme_id)

  end
end