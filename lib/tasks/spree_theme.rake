namespace :spree_theme do
  desc "load sample of theme, include spree_sample"
  task :load_sample  do
    Rake::Task["spree_sample:load"].invoke    
    load File.join(SpreeTheme::Engine.root,'db/samples.rb')
  end
  
  desc "reload section_piece.yml"
  task :reload_section_piece => :environment do
    Spree::SectionPiece.delete_all
    require 'active_record/fixtures'
    ActiveRecord::Fixtures.create_fixtures("#{SpreeTheme::Engine.root}/db/seeds", "spree_section_pieces") 
  end
end