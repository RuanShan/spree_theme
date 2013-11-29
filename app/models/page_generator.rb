#in layout, there are some eruby, all available varibles should be here.
class PageGenerator
  
  attr_accessor :template_release, :menu, :theme, :resource # resource could be product, blog_post, flash, file, image...
  attr_accessor :editor

  #these attributes are for templates
  attr_accessor :current_page_tag
  attr_accessor :context
  # renderer could be current controller or Erubis::Eruby,  
  # we would like to use helper method of rails, so now is using controller as renderer
  attr_accessor :is_preview, :controller, :renderer 
  attr_accessor :ehtml, :ecss, :ejs 
  delegate :generate, :generate_assets, :to=>:renderer
  delegate :html,:css,:js, :to=>:renderer

  class << self
    #page generator has two interface, builder and generator
    #builder only build content: ehtml,js,css
    #def builder( theme )
    #  self.new( theme, menu=nil)      
    #end
    
    #designer release a template
    def releaser( template_release)
      pg = self.new( template_release, menu=nil)
      pg.build
      pg
    end
    
    #generator generate content: html,js,css
    # params:
    #   theme_or_release: template theme or template release, a template may not released.
    def previewer(menu, theme_or_release=nil,  options={})
      options[:preview] = true
      pg = self.new( theme_or_release, menu, options)
      pg.build
      pg
    end    
    #generator generate content: html,js,css
    def generator(menu, theme_or_release=nil,  options={})
      self.new( theme_or_release, menu, options)
    end
  end
  
  def initialize( theme_or_release, menu, options={})
    if theme_or_release.kind_of? Spree::TemplateRelease
      self.template_release=  theme_or_release
      self.theme = theme_or_release.template_theme      
    else
      self.theme = theme_or_release 
      self.template_release = theme.template_releases.last
    end
    self.menu = menu
    self.resource = nil
    self.is_preview = options[:preview].present?
    
    self.editor = options[:editor]
    if options[:resource].present?
      self.resource = options[:resource]
    end
    html = css = js = nil
    ehtml = ecss = ejs = nil
    #init template variables, used in templates
    self.current_page_tag =   PageTag::CurrentPage.new(self)
    initialize_context_variables
    if options[:controller].present?
      self.controller = options[:controller]
    end    
  end
  
  def url_prefix      
    #self.is_preview ? "/preview" : ""
    ""
  end
  
  #def has_editor?
  #  self.editor.present?
  #end

  #build html, css sourse
  def build
    self.ehtml, self.ecss, self.ejs = self.theme.page_layout.build_content()      
    return self.ehtml, self.ecss, self.ejs
  end
  
  def release
    #build -> generate_assets -> serialize
    self.build            # build ehtml, ecss, ejs
    self.generate_assets  # generate css, js 
    serialize_page(:ehtml)
    serialize_page(:css)
    serialize_page(:js)
  end
  
  def renderer
    if @renderer.blank?     
      if self.controller.present?
        @renderer = PageRenderer::RailsRenderer.new(self.ehtml, self.ecss, self.ejs, self.context,self.controller)
      else
        @renderer = PageRenderer::ErubisRenderer.new(self.ehtml, self.ecss, self.ejs, self.context)
      end
    end    
    @renderer
  end
 
  def build_path(model)    
    url = nil
    if model.kind_of?( SpreeTheme.taxon_class )
      
      url= case model.mtype
        when 1 #home
          [self.url_prefix]  
        when 2 #cart
          [self.url_prefix,'cart']
        when 3 #checkout
          [self.url_prefix,'checkout']
        when 4 #thanks
          [self.url_prefix,'thanks']
        when 5 #signup
          [self.url_prefix,'signup']
        when 6 #login
          [self.url_prefix,'login']
        when 7 #accout
          [self.url_prefix,'account']
        else
          [self.url_prefix, model.id]  
        end.join('/')
      url = '/' if url.blank?  #[''].join('/')=>''      
    else  
      # menu.id would be nil if it is class DefaultTaxon
      # nil.to_i => 0
      url= [self.url_prefix, self.menu.id.to_i, model.id].join('/')    
    end    
    url
  end
  
  # *specific_attribute - ehtml,ecss, html, css
  def serialize_page(specific_attribute)
    specific_attribute_collection = [:css,:js,:ehtml]
    raise ArgumentError unless specific_attribute_collection.include?(specific_attribute)
    page_content = send(specific_attribute)
    if page_content.present?
      path = self.template_release.document_path
      FileUtils.mkdir_p(path) unless File.exists?(path)

      path = self.template_release.document_file_path(specific_attribute)      
      open(path, 'w') do |f|  f.puts page_content; end
    end
    
  end


  private
  # erb context variables 
  def initialize_context_variables
    self.context = {:current_page=>current_page_tag, 
      :website=>current_page_tag.website_tag, :template=>current_page_tag.template_tag
      }    
  end  

end

