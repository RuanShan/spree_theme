module Spree
  module Context
    module Base
      # use string instead of symbol, parameter from client is string 
      ContextEnum=Struct.new(:list,:detail,:cart,:account,:checkout, :thankyou,:signup,:login)[:list,:detail,:cart,:account,:checkout, :thankyou,:signup,:login]
      ContextEither = :""
      Contexts = [ContextEnum.values,ContextEither].flatten
      
      ContextDataSourceMap = { ContextEnum.list=>[:gpvs],ContextEnum.detail=>[:this_product]}
      DataSourceChainMap = {:gpvs=>[:gpv_product,:gpv_group, :gpv_either],
        :gpv_product=>[:product_images,:product_options], 
        :gpv_group=>[:group_products,:group_images],    
        :group_products=>[:product_images,:product_options],
        :this_product=>[]
        #keys should inclde all data_sources, test required.
        }
      DataSourceEmpty = :""
      mattr_accessor :request_fullpath
      
      def current_context
        raise "unimplement"
      end

      def context_either?
        current_context ==ContextEither
      end
    end
  end
end