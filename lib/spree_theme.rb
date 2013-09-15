require 'spree_core'
require 'spree_theme/engine'
require 'spree_theme/system'
require 'spree_theme/site_helper'

module SpreeTheme
  
  mattr_accessor :website_class, :taxon_class

  def self.website_class
    if @@website_class.is_a?(Class)
      raise "Spree.website_class MUST be a String object, not a Class object."
    elsif @@website_class.is_a?(String)
      @@website_class.constantize
    end
  end
  
  
  def self.taxon_class
    if @@taxon_class.is_a?(Class)
      raise "Spree.taxon_class MUST be a String object, not a Class object."
    elsif @@taxon_class.is_a?(String)
      @@taxon_class.constantize
    end
  end
end
