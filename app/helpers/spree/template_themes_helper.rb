module Spree
  module TemplateThemesHelper
  
    def my_remote_function(options)
      url = url_for( options[:url] )
      form =  options[:submit]
      confirm_function =  options[:confirm]
      callback = nil
  #    callback = %q! function (data, textStatus, xhr){ $("#editors").html(xhr.responseText); }!
      function = " ajax_post('#{url}','#{form}','script');return false;"
      if confirm_function.present?
        function = "if(confirm_function){#{function}}"
      end
      function
    end
  end
end