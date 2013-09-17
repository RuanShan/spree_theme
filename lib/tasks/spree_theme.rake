namespace :spree_theme do
  desc "load sample of theme"
  task :load_sample  => :environment do
    #Rake::Task["spree_sample:load"].invoke    
    load File.join(SpreeTheme::Engine.root,'db/sample/seed.rb')
  end
  
  desc "reload section_piece.yml"
  task :reload_section_piece => :environment do    
    load File.join(SpreeTheme::Engine.root,'db/seeds/00_section_pieces.rb')
  end
  
  desc "export template one"
  task :export_template => :environment do
    template = Spree::TemplateTheme.first
    serializable_data = template.serializable_data
    file_path =  File.join(SpreeTheme.site_class.dalianshopsdesigns.document_path, "#{template.id}_#{Time.now.to_i}.yml")
    open(file_path,'w') do |file|
      file.write(serializable_data.to_yaml)
    end
    puts "exported file #{file_path}"
  end
  
  desc "import template one"
  task :import_template => :environment do
    #template = Spree::TemplateTheme.first
    
    file_path =  File.join(SpreeTheme.site_class.dalianshopsdesigns.document_path, "1_*.yml")
    file_path = Dir[file_path].sort.last
    open(file_path) do |file|
      Spree::TemplateTheme.import_into_db(file)
    end    
    puts "imported file #{file_path}"
  end

end

