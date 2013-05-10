module Spree
  
  # release information of template
  class TemplateRelease < ActiveRecord::Base
    belongs_to :template_theme, :foreign_key=>"theme_id"

  end
end