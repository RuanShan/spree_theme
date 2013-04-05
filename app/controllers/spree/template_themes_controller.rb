module Spree
  class TemplateThemesController < Spree::StoreController
    cattr_accessor :layout_base_path
    self.layout_base_path = File.join(::Rails.root.to_s,"public","shops")   
  
    delegate :taxon_class,:website_class, :to=>:"SpreeTheme::Config"
    # GET /themes
    # GET /themes.xml
    def index
      @themes = TemplateTheme.all
  Rails.logger.debug "app=#{Rails.application.app}"
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @themes }
      end
    end
  
    # GET /themes/1
    # GET /themes/1.xml
    def show
      @theme = TemplateTheme.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @theme }
      end
    end
  
    #copy selected theme to new theme
    def copy
      @original_theme = TemplateTheme.find(params[:id])
      #copy theme, layout, param_value
      @new_theme = @original_theme.copy_to_new
      
      respond_to do |format|
        format.html { redirect_to(template_themes_url) }
      end    
    end

  
    # GET /themes/1/edit
    def edit
      @theme = TemplateTheme.find(params[:id])
    end
  
    # POST /themes
    # POST /themes.xml
    def create
      @theme = TemplateTheme.new(params[:theme])
  
      respond_to do |format|
        if @theme.save
          format.html { redirect_to(@theme, :notice => 'TemplateTheme was successfully created.') }
          format.xml  { render :xml => @theme, :status => :created, :location => @theme }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    # PUT /themes/1
    # PUT /themes/1.xml
    def update
      @theme = TemplateTheme.find(params[:id])
  
      respond_to do |format|
        if @theme.update_attributes(params[:theme])
          format.html { redirect_to(@theme, :notice => 'TemplateTheme was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    # DELETE /themes/1
    # DELETE /themes/1.xml
    def destroy
      @theme = TemplateTheme.find(params[:id])
      @theme.destroy
  
      respond_to do |format|
        format.html { redirect_to(template_themes_url) }
        format.xml  { head :ok }
      end
    end
    
    def build
      theme_id = params[:id]
      html, css = "", ""
      if TemplateTheme.exists?(theme_id)
        theme = TemplateTheme.find(theme_id)
        @lg = PageGenerator.builder(theme)
        html,css = @lg.build
        @lg.serialize_page(:ehtml)      
        @lg.serialize_page(:ecss)      
      end
    end
   
    
    # params for preview
    #    d: domain of website
    #    c: menu_id
    def preview
      #for debug
      params[:d] = 'www.rubyecommerce.com'
      editor = params[:editor]
      website=menu=layout=theme = resource = nil
      website = website_class.current
      if params[:c]
        menu = taxon_class.find_by_id(params[:c])
        if params[:r]
          resource = Product.find_by_id(params[:r])
        end  
      else
        menu = taxon_class.find_by_id(website.index_page)  
      end
      theme = TemplateTheme.find( website_class.current.theme_id)
      html,css = do_preview(theme, menu, {:resource=>(resource.nil? ? nil:resource),:editor=>editor,:controller=>self})
      #insert css to html
      style = %Q!<style type="text/css">#{css}</style>!
      
      #editor_panel require @theme, @editors, @editor ...
      prepare_params_for_editors(theme)
      editor_panel = render_to_string :partial=>'layout_editor_panel'
      html.insert(html.index("</head>"),style)
      html.insert(html.index("</body>"),editor_panel)
      render :text => html
    end
      
    def publish
      @website = website_class.current
      @menu_roots = taxon_class.roots
      @themes = TemplateTheme.all
    end
    
    def assign_default
      website_params = params[:website]
      self.website[:index_page] = website_params[:index_page].to_i
      self.website.save
      render_message("yes, updated!")    
      
    end
    
    def assign
      # "commit"=>[Update&Preview|Update|Preview]
      commit_command = params[:commit]
      keys = params.keys.select{|k|k=~/menu[\d]+/}
      menus_params = params.values_at(*keys)
      
      if commit_command=~/Update/
        #update default page
        website_params = params[:website]
        self.website_class.current.attributes = website_params
        self.website_class.current.save
        
      end
      
      if commit_command=~/Publish/
        do_publish
      end
      
      
      respond_to do |format|
        format.js  {
          if commit_command=~/Preview/
            render "preview"          
          else# commit_command=~/Publish/
            render_message("yes, publish")
          end    
        }
      end   
  
    end
    
    def select_tree
      
      @menu = taxon_class.find(params[:menu_id])
      
      render :partial=>"menu_and_template"
    end
    
    def edit_layout
      
    end
      
    def editor
      theme_id = 0
      layout_id = 0
      theme = TemplateTheme.find(params[:id])
      prepare_params_for_editors(theme)
      
      @template_themes = TemplateTheme.all
    end  
  
  
    # params
    #   layout_id: selected page_layout_id
    def update_layout_tree
      @theme = TemplateTheme.find(params[:id])
      op = params[:op]
      selected_page_layout_id = params[:layout_id]
      selected_id = params[:selected_id]
      selected_type = params[:selected_type]
      @selected_page_layout = @theme.page_layout.self_and_descendants.find(selected_page_layout_id)
      if op=='move_left'
        @selected_page_layout.move_left
      elsif op=='move_right'  
        @selected_page_layout.move_right
      elsif op=='add_child'    
        if selected_type=='Section'  
          @selected_page_layout.add_section(selected_id)
        else
          @selected_page_layout.add_layout_tree(selected_id)        
        end
        #@layout.reload      
      elsif op=='del_self'
        @selected_page_layout.destroy unless layout.root?
        @selected_page_layout = @selected_page_layout.parent
        #FIXME update param_values in editor        
        #@layout.reload
      end
      
      render :partial=>"layout_tree"    
    end
  
    # user disable a section in the current layout tree
    def disable_section
      layout_id = params[:layout_id]
      layout = PageLayout.find(layout_id)
      se = PageEvent::SectionEvent.new("disable_section", layout )
      se.notify
      
    end
    
    def get_param_values
      theme_id = params[:selected_theme_id]
      editor_id = params[:selected_editor_id]
      layout_id = params[:selected_page_layout_id]
          
      theme = TemplateTheme.find(theme_id)
      editor = Editor.find(editor_id)
      page_layout = PageLayout.find(layout_id) 
      prepare_params_for_editors(theme, editor, page_layout)
      
      respond_to do |format|
        format.html 
        format.js  {render :partial=>'editors'}
      end    
    end
  
    #FIXME, fix do_update_param_value
    def update_param_values
      selected_theme_id = params[:selected_theme_id]
      selected_editor_id = params[:selected_editor_id]
      param_value_keys = params.keys.select{|k| k=~/pv[\d]+/}
      
      for pvk in param_value_keys
        param_value_params = params[pvk]
        pv_id = pvk[/\d+/].to_i
        param_value = ParamValue.find(pv_id, :include=>[:section_param, :section])
        do_update_param_value(param_value, param_value_params) 
      end
      
    end
    
    def update_param_value
      param_value_event = params[:param_value_event]
      editing_param_value_id = params[:editing_param_value_id].to_i
      editing_html_attribute_id = params[:editing_html_attribute_id].to_i
      theme_id = params[:selected_theme_id]
      editor_id = params[:selected_editor_id]
      layout_id = params[:selected_page_layout_id]
      param_value_keys = params.keys.select{|k| k=~/pv[\d]+/}
      
        param_value_params = params["pv#{editing_param_value_id}"]
        source_param_value = ParamValue.find(editing_param_value_id, :include=>[:section_param, :section])
        updated_html_attribute_values = do_update_param_value(source_param_value, param_value_params, param_value_event, editing_html_attribute_id)
  
      #  param_value = ParamValue.find(editing_param_value_id)
      theme = TemplateTheme.find(theme_id)  
      editor = Editor.find(editor_id)
      page_layout = PageLayout.find(layout_id) 
      prepare_params_for_editors(theme,editor,page_layout)
     
      respond_to do |format|
        format.html 
        format.js  {render :partial=>'update_param_value',:locals=>{:source_param_value=>source_param_value,:updated_html_attribute_values=>updated_html_attribute_values}}
      end    
      
    end
    
      
    def prepare_params_for_editors(theme,editor=nil,page_layout = nil)
      @editors = Editor.all
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
      @sections = Section.roots
    end
    
    # Usage, update a param_value by param_value_param
    # Params, param_value ParamValue instance 
    #         param_value_params, hash, format as {"84"=>{"pvalue"=>"section_name", "psvalue"=>"0t"}}
    # Return, all updated_html_attribute_values, may include html_attribute_value belongs to other section, also include the source change, it is the first,
    #         it cause the serial changes.
    def do_update_param_value(param_value, param_value_params, param_value_event, editing_html_attribute_id)
      html_attribute = html_attribute_value_params = nil 
      param_value_params.keys.each {|ha_id|
        ha_id = ha_id.to_i
        if editing_html_attribute_id.nil? or editing_html_attribute_id==ha_id
          html_attribute = HtmlAttribute.find_by_ids(ha_id)
          html_attribute_value_params = param_value_params[ha_id.to_s]
          #event_params = {:html_attribute=>html_attribute,:html_attribute_value_params=>html_attribute_value_params}
          #param_value.raise_event(param_value_event, event_params)
        end      
      }
      param_value.update_html_attribute_value(html_attribute, html_attribute_value_params, param_value_event )
      #param_value.save
      param_value.updated_html_attribute_values
    end
    
    # usage - 1. popup file upload dialog
    #         2. handle submitted file 
    # params
    #   html_attribute_id
    #   param_value_id, 
    #   template_file - {"attachment"=>#<ActionDispatch::Http::UploadedFile:0xc9e77ec @original_filename="老郎酒1956精品酱香型531.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"template_file[attachment]\"; filename=\"\xE8\x80\x81\xE9\x83\x8E\xE9\x85\x921956\xE7\xB2\xBE\xE5\x93\x81\xE9\x85\xB1\xE9\xA6\x99\xE5\x9E\x8B531.jpg\"\r\nContent-Type: image/jpeg\r\n", @tempfile=#<File:/tmp/RackMultipart20130405-18221-1riv34n>>}
    def upload_file_dialog
      @dialog_content="upload_dialog_content"
      @param_value_id = params[:param_value_id]
      @html_attribute_id = params[:html_attribute_id].to_i
  @param_value = ParamValue.find(@param_value_id, :include=>[:section_param=>:section_piece_param])
  @editor = @param_value.section_param.section_piece_param.editor
      if request.post?
        
        uploaded_image = TemplateFile.new( params[:template_file] )
        if uploaded_image.valid?
          uploaded_image['theme_id']=@param_value.theme_id              
          if uploaded_image.save
  logger.debug "uploaded_image = #{uploaded_image.inspect}"          
                # update param value to selected uploaded image
                param_value_params={@html_attribute_id.to_s=>{"unset"=>"0", "pvalue0"=>uploaded_image.attachment_file_name, "psvalue0"=>"0i"}}
                param_value_event = ParamValue::EventEnum[:pv_changed]
                editing_html_attribute_id = @html_attribte_id
                do_update_param_value(@param_value, param_value_params, param_value_event, editing_html_attribute_id) 
                # get all param values by selected editor
                # since we redirect to editors, these are unused
                @param_values = ParamValue.within_section(@param_value).within_editor(@editor)
                # update param value
                render :partial=>'after_upload_dialog' 
          end
        else
        end
      else
        @theme = TemplateTheme.find(@param_value.theme_id)
        model_dialog("File upload dialog",@dialog_content)    
      end
    end
   
    
    def check_upload_file_name
      file_name = params[:file_name]
      is_existing = TemplateFile.exists?( ["file_name=?", file_name])
      if is_existing
        # render "replace"
      else
        # render "upload"      
      end
    end
    
    def do_publish
        # find all theme used by website
      theme_ids = taxon_class.assigned_theme_ids()
      if not theme_ids.empty?
        for theme_id in theme_ids
          theme = TemplateTheme.find(theme_id)
          do_build(theme)
        end
      end
    end
    
      # build ehtml,css,js
    def do_build( theme, options={})
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
    
    def do_preview( theme,  menu, options={})
        options[:preview] = true #preview_template_themes_url
        
        @lg = PageGenerator.previewer( menu, theme, options)
        html = @lg.generate
        css,js  = @lg.generate_assets
        if options[:serialize_html]
          @lg.serialize_page(:html)
        end
        if options[:serialize_css]      
          @lg.serialize_page(:css)
        end
        return html, css, js  
    end
  
    def do_generate( theme, menu, options={})
  
        @lg = PageGenerator.generator( theme, menu, options)
        html, css = @lg.renderer.generate_from_erb_file
        return html, css      
    end
      
    def public
      params[:d] = 'www.rubyecommerce.com'
      
      website=menu=layout=theme = nil
      website = SpreeTheme::Config.website_class.current
      if params[:c]
        menu = taxon_class.find_by_id(params[:c])
      else
        menu = taxon_class.find_by_id(website.index_page)  
      end
      theme = TemplateTheme.find(menu.find_theme_id(is_preview=true))
      html, css = do_generate(theme,  menu)
      render :text => html
    end
    
    private
    def model_dialog(dialog_title, dialog_content)
      @dialog_title = dialog_title
      @content_string = render_to_string :partial => dialog_content
      respond_to do |format|
          format.js{ render "base/model_dialog"}
      end
    end
    
    def render_message(message)
      respond_to do |format|
          format.js{ render "base/message_box", :locals=>{:message=>message}}
      end
        
    end

    
  end

end