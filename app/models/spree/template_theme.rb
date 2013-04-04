module Spree
  #it is a theme of page_layout
  class TemplateTheme < ActiveRecord::Base
    #extend FriendlyId
  
    #belongs_to :website #move it into template_theme_decorator
    belongs_to :page_layout, :foreign_key=>"page_layout_root_id", :dependent=>:destroy
    has_many :param_values, :foreign_key=>"theme_id" #  :dependent=>:destroy, do not use dependent, it cause load each one of param_value
    has_many :template_files, :foreign_key=>"theme_id" #  :dependent=>:destroy, do not use dependent, it cause load each one of param_value
    
    scope :by_layout,  lambda { |layout_id| where(:page_layout_root_id => layout_id) }
    serialize :assigned_resource_ids, Hash
    #friendly_id :title,:use => :scoped, :scope => :website
  
    after_destroy :remove_relative_data
    attr_accessible :website_id,:page_layout_root_id,:title
    
    class << self
      # template has page_layout & param_values
      # 
      def create_plain_template( section, title, attrs={})
        #create a theme first.
        website_id = SpreeTheme::Config.website_class.current.id
        template = TemplateTheme.create({:website_id=>website_id,:title=>title}) do|template|
          #fix Attribute was supposed to be a Hash, but was a String
          template.assigned_resource_ids={}
        end
        page_layout_root = template.add_section( section ) 
        template.update_attribute("page_layout_root_id",page_layout_root.id)
        
        template
      end
      
    end
    
    
    begin 'for page generator'  
      def file_name(usage)
        "#{page_layout_root_id}_#{id}.#{usage}"
      end
    end
    
    begin 'edit template'
      # Usage: user want to copy this layout&theme to new for editing or backup.
      #        we need copy param_value and theme_images
      #        note that it is only for root. 
      def copy_to_new()
    
        original_layout = self.page_layout    
        #copy new whole tree
        new_layout = original_layout.copy_to_new
        #create theme record
        new_theme = self.dup
        new_theme.layout_id = new_layout.id
        new_theme.save!
        
        #copy param values
        #INSERT INTO tbl_temp2 (fld_id)    SELECT tbl_temp1.fld_order_id    FROM tbl_temp1 WHERE tbl_temp1.fld_order_id > 100;
        table_name = ParamValue.table_name
        
        table_column_names = ParamValue.column_names
        table_column_names.delete('id')
        
        table_column_values  = table_column_names.dup
        table_column_values[table_column_values.index('layout_root_id')] = new_layout.id
        table_column_values[table_column_values.index('theme_id')] = new_theme.id
        
        #copy param value from origin to new.
        sql = %Q!INSERT INTO #{table_name}(#{table_column_names.join(',')}) SELECT #{table_column_values.join(',')} FROM #{table_name} WHERE  (theme_id =#{self.id})! 
        self.class.connection.execute(sql)
        #update layout_id to new_layout.id    
        for node in new_layout.self_and_descendants
          original_node = original_layout.self_and_descendants.select{|item| (item.section_id == node.section_id) and (item.section_instance==node.section_instance) }.first
          ParamValue.update_all(["page_layout_id=?", node.id],["theme_id=? and page_layout_id=?",new_theme.id, original_node.id])
        end
        return new_theme
      end
    
      #
      # Usage: modify layout, add the section instance as child of current node into the layout,
      # Params: 
      #   page_layout, instance of model PageLayout
      #   relationship, 'parent', 'silbing'
      #   selected_page_layout, there should be selected one, except adding root page_layout
      # return: added page_layout record
      # 
      def add_section(section, selected_page_layout=nil, attrs={})
        # check section.section_piece.is_container?
        obj = nil
        if section.root? 
          section_instance = 1
          if selected_page_layout.present?
            raise ArgugemntError, 'only container could has child section' unless selected_page_layout.section.section_piece.is_container       
            whole_tree = selected_page_layout.root.self_and_descendants
            section_instance = whole_tree.select{|xnode| xnode.section_id==section.id}.size.succ
          end
          attrs[:title]||="#{section.title}#{section_instance}"        
          obj = PageLayout.create do|obj|
            obj.section_id, obj.section_instance=section.id, section_instance
            obj.assign_attributes( attrs )
            obj.root_id = selected_page_layout.root_id if selected_page_layout.present?
            obj.website_id = SpreeTheme::Config.website_class.current.id
            obj.is_full_html = section.section_piece.is_root?
          end
          if selected_page_layout.present?
            obj.move_to_child_of(selected_page_layout)
          else
            obj.update_attribute("root_id",obj.id)
          end
          #copy the default section param value to the layout
          obj.add_param_value(self)
        end
        obj
      end
          
    end
    begin 'export&import'
      # export to yaml, include page_layouts, param_values, template_files
      # it is a hash with keys :template, :param_values, :page_layouts
      def serializable_data
        template = self.class.find(self.id,:include=>[:param_values,:page_layout=>:full_set_nodes])
        hash ={:template=>template, :param_values=>template.param_values, :page_layouts=>template.page_layout.full_set_nodes} 
        hash      
      end
      
      # it would delete existing one first, then import
      # params
      #   file - opened file 
      def self.import( file )
        #require class
        Spree::ParamValue; Spree::PageLayout;
Rails.logger.debug "import:#{file.path}"        
        serialized_hash = YAML::load(file)
Rails.logger.debug "imported:#{serialized_hash }"        
        template = serialized_hash[:template]
        if self.exists?(template[:id])
          existing_template = self.find(template[:id])
          if existing_template.page_layout.themes.count==1
            #dele page_layouts     
            existing_template.page_layout.destroy       
          end
          existing_template.destroy
        end
Rails.logger.debug "start to insert.."        
        connection.insert_fixture(template.attributes, self.table_name)
        serialized_hash[:param_values].each do |record|
          table_name = ParamValue.table_name
Rails.logger.debug "insert param_values=#{record}"        
          connection.insert_fixture(record.attributes, table_name)          
        end
        serialized_hash[:page_layouts].each do |record|
          table_name = PageLayout.table_name
Rails.logger.debug "insert page_layouts"        
          connection.insert_fixture(record.attributes, table_name)          
        end
        
      end
    end
    def remove_relative_data
      ParamValue.delete_all(["theme_id=?", self.id])
    end
    
    begin 'assigned resource'
      # all menus used by this theme, from param values which pclass='db'
      # param_value.pvalue should be menu root id
      # return menu roots
      def assigned_menus

      end
      
      # get assigned menu by specified page_layout_id
      def assigned_resource_id( resource_class, page_layout_id)
        resource_id = 0
        resource_key = get_resource_class_key(resource_class)
  Rails.logger.debug "resource_key=#{resource_key}, page_layout_id=#{page_layout_id}"      
        if assigned_resource_ids.try(:[],page_layout_id).try(:[],resource_key).present?
          resource_id = assigned_resource_ids[page_layout_id][resource_key].first
        end
        resource_id
      end
    
      # assign resource to page_layout node
      def assign_resource( resource, page_layout)
        #assigned_resource_ids={page_layout_id={:menu_ids=>[]}}
        self.assigned_resource_ids = {} unless assigned_resource_ids.present?
        
        resource_key = get_resource_class_key(resource.class)
        unless self.assigned_resource_ids[page_layout.id].try(:[],resource_key).try(:include?, resource.id )
          self.assigned_resource_ids[page_layout.id]||={}
          self.assigned_resource_ids[page_layout.id][resource_key]||=[]
          self.assigned_resource_ids[page_layout.id][resource_key].push( resource.id )
        end
        Rails.logger.debug "assigned_resource_ids=#{assigned_resource_ids.inspect}"
        self.save! 
      end
    end
    
    begin 'param values'
      def html_page
        HtmlPage.new(self)
      end
        
        # param values of self.
      def full_param_values(editor_id=0)
        if editor_id>0
        ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
         :conditions=>["theme_id=? and section_piece_params.editor_id=?", self.id, editor_id],
         :order=>"section_piece_params.editor_id, param_categories.position")
          
        else
        ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
         :conditions=>["theme_id=?", self.id],
         :order=>"section_piece_params.editor_id, param_categories.position")
            
        end
      end
    
    
      def get_resource_class_key( resource_class)
        resource_class.to_s.underscore.to_sym
      end
    end    
  end
end