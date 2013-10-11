module Spree
  module Context
    module Taxon
      include Spree::Context::Base
            # context of default taxon vary in request_fullpath
      # ex. /cart  context is cart
      #     /user  context is account
      # return :either(detail or list), cart, checkout, register, login
      def current_context
        #TODO verify thankyou page.
        case self[:request_fullpath]
          when /^\/[\d]+\/[\d]+/
            ContextEnum.detail
          when /^\/cart/
            ContextEnum.cart
          when /^\/user/,/^\/password/ 
            ContextEnum.account
          when /^\/checkout/
            ContextEnum.checkout
          when /^\/login/, /^\/checkout\/registration/
            ContextEnum.login      
          when /^\/signup/
            ContextEnum.signup
          else
            ContextEnum.list
          end
      end
    end
  end
  
end
  