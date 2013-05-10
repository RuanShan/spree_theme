Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  resources :template_themes do
     member do
       get :editor
       get :edit_layout # modify page_layout
       post :get_param_values # to support post data>1024byte
       post :update_param_value
       post :update_layout_tree
       get :build
       get :generate_assets
     end

     collection do
       get :preview # add function preview_template_themes_path
       get 'publish'
       get 'upload_file_dialog'
       post 'upload_file_dialog'
       post :assign
     end
  end
  
  match '(/:c(/:r))' => 'template_themes#preview', :c => /[\d]+/
  match 'preview(/:c(/:r))' => 'template_themes#preview' #preview home
 
  namespace :admin do
    resources :template_themes do
      member do
        post :copy
        post :release
      end
    end
  end
end
