Music3::Application.routes.draw do |map|
  resources :albums

  resources :artists, :artist_home, :songs
     devise_for :users

  root :to => "homepage#index"

  # Artist Routes
  # Url Slug Routing
  match "/:url_slug" => "artists#show", :as => :artist_link
  match "/:url_slug/edit" => "artists#edit", :as => :edit_artist
  match "/:url_slug/add_song" => "songs#new", :as => :add_song
  match "/:url_slug/new_album" => "albums#new", :as => :add_album

  #Song Routes
  # Url Slug Routing
  match "/:url_slug/song/:song_url_slug" => "songs#show", :as => :artist_show_song


  #Albums Slug Routing
  match "/:url_slug/album/:album_url_slug" => "albums#show", :as => :artist_show_album
  match "/Ted/34/download2" => "albums#download_album", :as => :album_download
  #Artist Home

  match "/:url_slug/admin" => "artists#admin", :as => :artist_admin

 # songs routing

  #match "/hooper/:test" => "songs#show", :as => :song_link
  match "songs/upload", :as => "upload"
  #match "song/delete" => "songs#delete", :as => "delete"
  #match "song/new/:id" => "songs#new", :as => "new_song_id"
  match "songs/create" => "songs#create", :as => "new_song_post"

 get "songs/index"
 get "songs/upload"
 get "songs/delete"


 # Albums routing

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  #root :to => "songs#index"


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

end
