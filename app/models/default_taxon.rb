class DefaultTaxon < SpreeTheme.taxon_class
  include Spree::Context::Taxon

  def self.instance
    self.new
  end
  
  def name
    "Default #{current_context}"
  end
  
end