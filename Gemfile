source 'http://rubygems.org'

group :test do
  gem 'ffaker'
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end
gem 'spree', :github => "spree/spree", :branch => "master"

group :test,:development do
  #using backend required
  gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => 'master'
  gem "mysql2"
end
gem "acts_as_list"
gem "acts_as_tree"
gem "awesome_nested_set"

#use paperclip instead of dragonfly,  dragonfly have no way to configure image path
#gem "paperclip", "2.8.0" # spree require it.
gem "responds_to_parent"
gem 'jquery-rails', '>= 1.0.12'
gem "friendly_id", "~> 4.0.9"

group :assets do
  gem 'coffee-rails'
end

gemspec
