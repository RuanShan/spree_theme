#encoding: utf-8
module Spree
  UsersController.class_eval do
     respond_to :html, :js

     def edit
       respond_to do |format|
         format.js{ render "spree/shared/dialog" }
       end
     end
  end
end