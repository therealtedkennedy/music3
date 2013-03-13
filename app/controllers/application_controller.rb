class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  #Amazon buckets
  BUCKET ='ted_kennedy'
  ALBUM_BUCKET = 'ted_kennedy_album'
  #Number of download codes avaible to artist
  CODE_LIMIT = 250

  #
  #POLICY_DOCUMENT = ActiveSupport::JSON.encode(:expiration => "2012-10-01T00:00:00Z",
	#				:conditions => [:bucket => BUCKET,
	#								:'starts-with'=> ["$key", ""],
	#								#:acl=> "private",
	#								#:success_action_redirect=> "http://localhost:3000/",
	#								#:'starts-with'=>["$Content-Type", ""],
	#								#:'content-length-range' => [0, 1048576]
	#				]
  #)
  POLICY_DOCUMENT = '{"expiration": "2013-01-01T00:00:00Z",
  "conditions": [
    [ "eq", "$bucket","'+BUCKET+'"],
    ["starts-with", "$key", ""],
    {"acl": "public-read"},
    {"success_action_redirect": "http://localhost:3000/"},
    ["starts-with", "$Content-Type", ""],
    ["content-length-range", 0, 524288000],
    [ "starts-with", "$x-amz-meta-my-file-name", "" ],
    [ "starts-with", "$Content-Disposition", "" ],

  ]
}'
  # Fixes SSL Error - http://www.techques.com/question/1-5360622/Problems-with-SSL-dependent-gems-OAuth2---ActiveMerchant
  #this might be a security problem.
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  #
  #def after_sign_in_path_for(resource_or_scope)
  #
  #  # stored_location_for(resource) ||
  #  if resource_or_scope.is_a?(User)
  #    # (session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
  #
  #    #(session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
  #    #show_user_path(current_user.id)
  #  else
  #    super
  #  end
  #end
#
#  def after_sign_in_path_for(resource)
#    if(session[:"user.return_to"].nil?)
#       #"/artists"
#      :referrer
#    else
#      session[:"user.return_to"].to_s
#    end
#  end
#end


  # Customize the Devise after_sign_in_path_for() for redirecct to previous page after login

  #def after_sign_in_path_for(resource_or_scope)

  #  case resource_or_scope
  #  when :user, User
   #   store_location = session[:return_to]
    #  clear_stored_location
    #  (store_location.nil?) ? "/artists" : store_location.to_s
  #  else
   #   super
 #   end
# end



# config/initializers/dev_environment.rb
  #unless Rails.env.production?



 # end

  #*************Everything social *********


  #logic around witch faceboook url is used.  Used by #show and artist promo
  def facebook_url(artist)
	  if artist.fb_page_url.blank?
		  @social_fb_url = artist_link_url(artist.url_slug)
	  else
		  @social_fb_url = artist.fb_page_url
	  end
  end

   #artist social used by artist
  def artist_social(artist)
	  #-----------For Artist Meta Tags----------------

	  #Page Title, Facebook Title and Twitter Title
	  @social_title = artist.name+" on Three Repeater"
	  #Meta description (google), Facebook Description, and Twitter Card Description
	  @social_descrip = artist.bio

	  #logic around figuring out which facebook url is used
	  facebook_url(artist)

	  #Twitter ID
	  @social_twitter_name = artist.twitter_name

	  #Image for twitter and FB
	  @social_image = artist.logo_url.to_s

	  #------------------------------------------------

  end


  #calls social info for albums.  Used by album show, and socail_promo
  def album_social(artist,album)

	  #-----------For Album Meta Tags----------------

	  #Page Title, Facebook Title and Twitter Title
	  @social_title = @album.al_name+" by "+ @artist.name+" on Three Repeater"
	  #Meta description (google), Facebook Description, and Twitter Card Description
	  @social_descrip = album.description

	  #facebook url
	  @social_fb_url = artist_show_album_url(artist.url_slug,album.album_url_slug)


	  #Twitter ID
	  @social_twitter_name = artist.twitter_name

	  #Image for twitter and FB
	  if album.art.blank?
		  @social_image = artist.logo_url.to_s
	  else
		  @social_image = album.art_url.to_s
	  end

  end

  def song_social(artist,song)

	  #-----------For Songs Meta Tags----------------

	  #Page Title, Facebook Title and Twitter Title
	  @social_title = song.song_name+" by "+ artist.name+" on Three Repeater"
	  #Meta description (google), Facebook Description, and Twitter Card Description
	  @social_descrip = "Listen to "+song.song_name+" by "+ artist.name + "on Three Repeater today!"

	  #facebook url
	  @social_fb_url = artist_show_song_url(artist.url_slug, song.song_url_slug)


	  #Twitter ID
	  @social_twitter_name = artist.twitter_name

	  #Image for twitter and FB
	  @social_image = artist.logo_url.to_s

	  #------------------------------------------------

 end

#over rides devise default rout after sign in
 private
 #don't know
 def stored_location_for(resource_or_scope)
     nil
 end


  #not sure if  this is used anymore

 def user_auth_redirect_path
	 cookies[:object] = {
			 :value => params[:object],
			 :expires => 30.minutes.from_now
	 }

	 cookies[:artist] = {
			 :value => params[:url_slug],
			 :expires => 30.minutes.from_now
	 }

	 cookies[:song_album_or_event_slug] = {
			 :value => params[:song_album_or_event_slug],
			 :expires => 30.minutes.from_now
	 }

 end


  before_filter :instantiate_controller_and_action_names

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
 #redirects to the sign_in_routing_path in the user model
 def after_sign_in_path_for(resource_or_scope)
      sign_in_routing_path

     # @object = cookies[:object]
     #@song_album_or_event_slug = cookies[:song_album_or_event_slug]
     # assign_to_user (cookies[:object],cookies[:song_album_or_event_slug])
 end



  def order_create (object,token)



    @order = object.orders.build(@order)
    @order.express_token = token
    @order.ip_address = request.remote_ip





    if @order.save
      @order.purchase
       # if @order.purchase
          #redirect_to(album_download_path(@album.al_a_id, @album.id), :notice => 'Artist was successfully updated.')
        # render :action => "success"
      #  else
       #  render :action => "failure"
      #  end
      # else
      #  render :action => 'new'
     end

  end

  #assigns an object to a user (album, artist, song, ticket, anything you want)
  def assign_to_user (object,object_url_slug)
    if object == "album"
      @user = User.find(current_user.id)
      @album = Album.find_by_album_url_slug(object_url_slug)
      @album.users << @user
      @album.save
      cookies[:object] = {:expires => 1.year.ago}
      cookies[:song_album_or_event_slug] = {:expires => 1.year.ago}
    end
  end

	#finds song objects, when album and URL slug are given
	def find_song(artist, url_slug)

		artist.songs.uniq.each do |song|
			if song.song_url_slug == url_slug
				@song = song

			else

			end
		end
	end


	#finds album objects, when only album url slug is given
	def find_album(artist,url_slug)

		artist.albums.uniq.each do |album|
			if album.album_url_slug == url_slug
				@album = album
			end
		end
	end
	#For resizing profile picks
	#def limit_image_url (file_name)
	#	@name = file_name.split("/")[1]
	#	@image_url = "http://res.cloudinary.com/hyy026ob8/image/upload/w_50,h_50,c_limit/"+@name
	#end
end




