require 'spree/core/controller_helpers/common'
class << Spree::Core::ControllerHelpers::Common  
  def included_with_theme_support(receiver)
    included_without_theme_support(receiver)
    receiver.send :include, SpreeTheme::System
    receiver.send :layout, :get_layout_if_use
    receiver.send :before_filter, :initialize_template
  end
  alias_method_chain :included, :theme_support   
end

module SpreeTheme::System
  private
  # override spree's
  # only cart|account using layout while rendering, product list|detail page render without layout.
  def get_layout_if_use
    #for designer
    if @is_designer
      return 'layout_for_design'
    end 
    #for customer
    if @is_preview 
      return 'layout_for_preview'
    end  
    SpreeTheme::Config.website_class.current.layout.present? ? SpreeTheme::Config.website_class.current.layout : Spree::Config[:layout]
  end

  def initialize_template
      website = SpreeTheme::Config.website_class.current
      if params[:c]
        @menu = SpreeTheme::Config.taxon_class.find_by_id(params[:c])
        if params[:r]
          @resource = Spree::Product.find_by_id(params[:r])
        end  
      elsif params[:controller]=~/cart|checkout|order/
        @menu = DefaultTaxon.instance
        @menu[:page_type] = 'cart'
      else
        @menu = SpreeTheme::Config.taxon_class.find_by_id(website.index_page)  
      end
      @theme = Spree::TemplateTheme.find( website.theme_id)

      if Rails.env !~ /prduction/
        # for development or test, enable get site from cookies
        if cookies[:abc_development_design].present?
          @is_designer = true
          #user is designer.
        end     
      end
    unless request.xhr?
      if @is_designer      
         prepare_params_for_editors(@theme)
         @editor_panel = render_to_string :partial=>'/spree/base/layout_editor_panel'
      end
    end
  end
  
  def prepare_params_for_editors(theme,editor=nil,page_layout = nil)
      @editors = Spree::Editor.all
      @param_values_for_editors = Array.new(@editors.size){|i| []}
      editor_ids = @editors.collect{|e|e.id}
      page_layout ||= theme.page_layout
      param_values =theme.param_values().where(:page_layout_id=>page_layout.id).includes([:section_param=>[:section_piece_param=>:param_category]]) 
      #get param_values for each editors
      for pv in param_values
        #only get pv blong to root section
        #next if pv.section_id != layout.section_id or pv.section_instance != layout.section_instance
        idx = (editor_ids.index pv.section_param.section_piece_param.editor_id)
        if idx>=0
          @param_values_for_editors[idx]||=[]        
          @param_values_for_editors[idx] << pv
        end
      end 
  
      @theme =  theme   
      @editor = editor    
      @editor ||= @editors.first
      
      @page_layout = page_layout #current selected page_layout, the node of the layout tree.
      @page_layout||= theme.page_layout
      @sections = Spree::Section.roots
  end
  
end