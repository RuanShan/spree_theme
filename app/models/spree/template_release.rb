module Spree
  
  # release information of template
  class TemplateRelease < ActiveRecord::Base
    belongs_to :template_theme, :foreign_key=>"theme_id"

    def path
      File.join( 'themes', "t#{self.theme_id}_r#{self.id}")
    end
  end
end