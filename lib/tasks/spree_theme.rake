namespace :spree_theme do
  desc "load sample of theme, include spree_sample"
  task :load_sample  do
    Rake::Task["spree_sample:load"].invoke    
    load File.join(SpreeTheme::Engine.root,'db/samples.rb')
  end
end