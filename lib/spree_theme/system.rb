require 'spree/core/controller_helpers/common'
class << Spree::Core::ControllerHelpers::Common  
  def included_with_theme_support(receiver)
    included_without_theme_support(receiver)
    receiver.send :include, SpreeTheme::System
    receiver.send :layout, :get_layout_if_use
    receiver.send :before_filter, :initialize_template
    receiver.send :before_filter, :add_view_path #spree_devise_auth, and spree_core require it.
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
    SpreeTheme.site_class.current.layout || Spree::Config[:layout]
  end

  def initialize_template
Rails.logger.debug "request.fullpath=#{request.fullpath}"    
    return if request.fullpath == '/under_construction'
    return if request.fullpath == '/create_admin_session'
    return if( request.fullpath == '/user/spree_user/logout' or request.fullpath == '/logout') 
    return if request.fullpath =~ /^\/admin/    
    website = SpreeTheme.site_class.current
    #DefaultTaxon.instance.id => 0
    if params[:controller]=~/cart|checkout|order/
      @menu = DefaultTaxon.instance
      @menu[:page_type] = 'cart'
    elsif params[:controller]=~/user/
      @menu = DefaultTaxon.instance
      @menu[:page_type] = 'account'
    else
      if params[:r]
        @resource = Spree::Product.find_by_id(params[:r])
      end
      if params[:c] and params[:c].to_i>0 
        @menu = SpreeTheme.taxon_class.find_by_id(params[:c])
      elsif website.index_page > 0
        @menu = SpreeTheme.taxon_class.find_by_id(website.index_page)
      else
        @menu = DefaultTaxon.instance
      end
      if @resource.present?
        #@menu[:page_type] = 'detail'
      end
    end

    @is_designer = website.design?
    if Rails.env !~ /prduction/
      # for development or test, enable get site from cookies
      if cookies[:abc_development_design].present?
        @is_designer = true
        #user is designer.
      end     
    end    
    #get template from query string 
    if @is_designer
      if params[:action]=='preview' && params[:id].present?
        @theme = Spree::TemplateTheme.find( params[:id] )          
      end
    end
    template_release =  SpreeTheme.site_class.current.template_release
    #browse template by public
    if @theme.blank? and template_release.present?       
      @theme = template_release.template_theme
    end

    # site has a released theme    
    if template_release.present?  
      unless request.xhr?
        if @is_designer      
           prepare_params_for_editors(@theme)
           # layout_editor_panel has to be in views/application, 
           # or could not find for spree_auth_devise/controllers
           @editor_panel = render_to_string :partial=>'layout_editor_panel'
        end
      end
      # we have initialize PageGenerator here, page like login  do not go to template_thems_controller/page
      @lg = PageGenerator.generator( @menu, template_release, {:resource=>@resource,:controller=>self})
      @lg.context.each_pair{|key,val|
        instance_variable_set( "@#{key}", val)
      }      
    else
      redirect_to :under_construction
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
      #template selection
      @template_themes = Spree::TemplateTheme.all
  end
  
  def add_view_path
    #!!is it a place cause memory overflow?
    append_view_path SpreeTheme.site_class.current.document_path
  end
end