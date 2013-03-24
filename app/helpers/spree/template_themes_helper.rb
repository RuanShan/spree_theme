module Spree
  module TemplateThemesHelper
  
    def my_remote_function(options)
      url = url_for( options[:url] )
      form =  options[:submit]
      callback = nil
  #    callback = %q! function (data, textStatus, xhr){ $("#editors").html(xhr.responseText); }!
      return " ajax_post('#{url}','#{form}','script');return false;"
      
    end
  end
end