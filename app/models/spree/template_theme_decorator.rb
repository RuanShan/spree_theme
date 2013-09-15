# This is the primary location for defining spree preferences
#
# The expectation is that this is created once and stored in
# the spree environment
#
# setters:
# a.color = :blue
# a[:color] = :blue
# a.set :color = :blue
# a.preferred_color = :blue
#
# getters:
# a.color
# a[:color]
# a.get :color
# a.preferred_color
#
Spree::TemplateTheme.class_eval do
  belongs_to :website, :class_name => SpreeTheme.website_class.to_s, :foreign_key => "website_id"
  
end
