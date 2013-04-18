module Spree
  module BaseHelper
  
    def my_remote_function(options)
      full_query_path = options[:query_path]+"?"+options[:query_params].to_param 
      form =  options[:submit]
      confirm_function =  options[:confirm]
      callback = nil
  #    callback = %q! function (data, textStatus, xhr){ $("#editors").html(xhr.responseText); }!
      function = " ajax_post('#{full_query_path}','#{form}','script');return false;"
      if confirm_function.present?
        function = "if(confirm_function){#{function}}"
      end
      function
    end
  end
end