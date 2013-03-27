# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
###################################################################################################################################################################################################################################################################################################################################################################################
#  
# rake RAILS_ENV=test db:seed

# plese load section_pieces first, seed sections.rb need it.

seeds_path = File.join(File.dirname(__FILE__), 'seeds')

require 'active_record/fixtures'
ActiveRecord::Fixtures.create_fixtures(seeds_path, "spree_section_pieces")   

#suffix number of seeds file name indicate loading order. 
xpath = File.join(seeds_path, "*.rb")
Dir[xpath].sort.each {|file| 
  puts "loading #{file}"
  load file
}


###################################################################################################################################################################################################################################################################################################################################################################################   
# Section

puts "loading complete!"
