Music3::Application.routes.draw do

	resources :signed_urls, only: :index
	resources :artists, :albums,:orders,:artist_home, :songs, :profile_layouts, :my_records

    devise_for :users


    #socail promo
	match "/:url_slug/social_promo" => "artists#social_promo", :as => :social_promo


	root :to => "homepage#index"
	#orders

	match "orders/paypal/to_chained/:object/:url_slug/:song_album_or_event_id" => "orders#chained_payment", :as => :chained_payment
	match "orders/paypal/to_free_download/:object/:url_slug/:song_album_or_event_id" => "orders#free_download", :as => :download_free
	match "orders/pwyc" => "orders#pwyc", :as => :pwyc_form #route  pwyc form
	match "orders/payment_method/:object/:url_slug/:song_album_or_event_id" => "orders#payment_method", :as => :payment_method
	match "orders/paypal/login_prompt" => "orders#login_prompt", :as => :login_prompt #not sure if this is used anymore



   match "/go_suck_a_fucking_dick/rails_forms_are/dumb_cunts" => "profile_layouts#update_profile_layout"


	#user routing

	devise_scope :user do
		root :to => "users#new"
		match "users/show/:id" => "users#show", :as => "show_user"
		match "users/edit/:id" => "users#edit", :as => "edit_user"
		match "users/index" => "users#index"
		match "users/sign_out" => "users#destroy"
		match "users/update" => "users#boo"
		match "devise_work_around" => "users#sign_in_routing", :as => "sign_in_routing"
		match 'auth/:provider/callback', to: 'users#api_login'
		match 'auth/failure', to: redirect('/')

	end






	#devise redirect work around


	#transaction

	match "transactions" => "transactions#index", :as => :transactions
	match "transactions/paypal/ipn" => "transactions#ipn_save", :as => :ipn_save

	# Artist Routes
	# Url Slug Routing

	match "/:url_slug" => "artists#show", :as => :artist_link
	match "/:url_slug/css" => "artists#css", :as => :artist_css
	match "/:url_slug/edit" => "artists#edit", :as => :edit_artist
	match "/:url_slug/update-image" => "artists#artist_save_image", :as => :artist_save_image
	match "/:url_slug/new_album" => "albums#new", :as => :add_album
	match "/:url_slug/delete" => "artists#pre_delete", :as => :pre_delete

    #s3 update
	match "/:url_slug/add_song/update-s3-meta/:object_id/:object_type" => "s3_upload#update_s3_meta", :as => "update_s3_meta"

	#creates a profile for artists already in the DB

	match "/:url_slug/edit/update_field" => "profile_layouts#field_save", :as => :field_save

	match "/:url_slug/create/new_layout"  => "profile_layouts#new"
	match "/:url_slug/profile-edit/css-editor" => "profile_layouts#css_editor", :as => :css_editor
	match "/:url_slug/profile-edit" => "profile_layouts#edit", :as => :profile_edit
	match "/:url_slug/profile-edit/song/:song_url_slug" => "profile_layouts#edit_song", :as => :profile_edit_song
	match "/:url_slug/profile-edit/album/:album_url_slug" => "profile_layouts#edit_album", :as => :profile_edit_album
	match "/:url_slug/profile-edit/css-editor/update" => "profile_layouts#css_editor_update", :as => :css_editor_update
	match "/:url_slug/update_profile_layout" => "profile_layouts#update"


  #artist admin urls
	match "/:url_slug/admin" => "artists#admin", :as => :artist_admin
	#need to know figure out how the preview will work. Maybe always load artist pages in this layout...and just hide it! bam.  Good idea.
	#match "/:url_slug/admin/:song_url_slug" => "artists#show_song", :as => :admin_show_song
	#match "/:url_slug/admin/:album_url_slug" => "albums#show_show_album", :as => :admin_show_album





	#Albums Slug Routing - rule /slug/static/album_slug/static
	match "/:url_slug/albums" => "albums#index", :as => :artist_show_albums
	match "/:url_slug/album/:album_url_slug" => "albums#show", :as => :artist_show_album
	match "/:url_slug/album/:album_url_slug/download" => "albums#download_album", :as => :album_download
	match ":url_slug/album/:album_url_slug/playlist-create" => "albums#album_play_list_create", :as => :album_playlist_create
    match ":url_slug/album/:album_url_slug/edit/:id" => "albums#edit", :as => :album_edit
	match "/:url_slug/update-image/:album_id" => "albums#album_save_image", :as => :album_save_image
	match "/:url_slug/album/:album_url_slug/pre_delete" => "albums#pre_delete", :as => :album_pre_delete
	match "/:url_slug/album/:album_url_slug/delete/:album_id" => "albums#destroy", :as => :album_delete
	match "/:url_slug/album/:album_url_slug/zip/:album_id" => "albums#call_zip_album", :as => :call_album_zip
	match "/:url_slug/album/:album_url_slug/new-album-info/:id" => "albums#new_album_info", :as => :new_album_info

	#albums code routing
	match "/:url_slug/album/create-code/:id" => "album_code#show", :as => :album_create_code
	match "/album_codes/create" => "album_code#create"
	match "/:url_slug/code" => "albums#album_code_download", :as => :code_download
	match "/:url_slug/download-code/:code" => "albums#album_code_find", :as => :code_download_code
	match "/:url_slug/album_code_find" => "albums#album_code_find", :as => :find_album_code





	# songs routing

	#match "/hooper/:test" => "songs#show", :as => :song_link
	match "songs/upload", :as => "upload"
	#match "song/delete" => "songs#delete", :as => "delete"
	#match "song/new/:id" => "songs#new", :as => "new_song_id"
	match "songs/create" => "songs#create", :as => "new_song_post"
	match "/:url_slug/add_song" => "songs#new", :as => :add_song
	match "/:url_slug/songs" => "songs#index", :as => :artist_show_songs
	match "/:url_slug/song/:song_url_slug" => "songs#show", :as => :artist_show_song
	match "/api/incrementPlayCount/:song_id" => "songs#song_play_counter", :as => :song_play_counter
	# match "/:url_slug/song/:song_url_slug/edit => "
	match "/:url_slug/song-delete/:song_id" => "songs#destroy", :as => "song_destroy"
	match "/:url_slug/song/:song_url_slug/edit/:id" => "songs#edit", :as => :song_edit
	match "/:url_slug/song-image-save/:song_id" => "songs#song_save_image", :as => :song_save_image

	#get "songs/index"
	get "songs/upload"
	#get "songs/delete"






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
