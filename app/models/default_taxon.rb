class DefaultTaxon < SpreeTheme.taxon_class
  include Spree::Context::Taxon

  def self.instance( request_fullpath=nil)
    default_taxon = self.new
    default_taxon.request_fullpath = request_fullpath
    default_taxon
  end
  
  def name
    "Default #{current_context}"
  end
  
end