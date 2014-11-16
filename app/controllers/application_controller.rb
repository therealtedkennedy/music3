class ApplicationController < ActionController::Base



  #Amazon buckets
  #Change in Application Helper as well!!!  YES! YOUR AN IDIOT FOR NOT READING THIS THE FIRST TIME!
  if Rails.env.production?
    #Change in Application Helper as well!!!  YES! YOUR AN IDIOT FOR NOT READING THIS THE FIRST TIME!
    BUCKET ='production_songs'
    ALBUM_BUCKET = 'production_albums'
    IMAGE_BUCKET = 'production_images_1'

  else
    #Change in Application Helper as well!!!  YES! YOUR AN IDIOT FOR NOT READING THIS THE FIRST TIME!
    BUCKET ='ted_kennedy'
    ALBUM_BUCKET = 'ted_kennedy_album'
    IMAGE_BUCKET = 'ted_kennedy_image'

  end


  protect_from_forgery
  include SessionsHelper






  S3_KEY="z+DmlVpM1omU5AaTlyRxsqhHiq/57M9CGEQbc+gd"

  #Number of download codes avaible to artist
  CODE_LIMIT = 250

  before_filter :authenticate
  after_filter :ajax_back_stop

  def authenticate
	  if Rails.env.dev_kennedy?
		  authenticate_or_request_with_http_basic do |username, password|
			  username == "trentr" && password == "Notnin1794$$"
		  end
	  end
  end

  def ajax_back_stop
	  if request.xhr?
		  response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		  response.headers["Pragma"] = "no-cache"
		  response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
	  end
  end
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
	  @social_image = artist.logo.to_s

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
		  @social_image = artist.logo.to_s
	  else
		  @social_image = album.art.to_s
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
	  @social_image = artist.logo.to_s

	  #------------------------------------------------

 end

#over rides devise default rout after sign in
 private
 #don't know
 def stored_location_for(resource_or_scope)
     nil
 end


  #not sure if  this is used anymore

 #def user_auth_redirect_path
	# cookies[:object] = {
	#		 :value => params[:object],
	#		 :expires => 30.minutes.from_now
	# }
 #
	# cookies[:artist] = {
	#		 :value => params[:url_slug],
	#		 :expires => 30.minutes.from_now
	# }
 #
	# cookies[:song_album_or_event_slug] = {
	#		 :value => params[:song_album_or_event_slug],
	#		 :expires => 30.minutes.from_now
	# }
 #
 #end


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


	# S3 Methods
	#initilaizes s3 object
	def s3_start
		@s3 = AWS::S3.new
	end

	#checks if objects exists
	def S3_object_exists(bucket, s3_id)
		s3_start
		@s3.buckets[bucket].objects[s3_id].exists?

	end

	def s3_url_for(bucket, s3_id)
		s3_start
		@s3_url = @s3.buckets[bucket].objects[s3_id].public_url
		@s3_url.to_s
	end


	def s3_delete (bucket, s3_id)
		s3_start
		@s3.buckets[bucket].objects[s3_id].delete
	end

   def s3_save(amazon_id,file,name,s3_bucket,content_type,file_type)
	   s3_start
	   @s3.buckets[s3_bucket].objects[amazon_id].write(file.read,{:acl => :public_read, :content_disposition =>'attachment;filename='+name+file_type, :content_type => content_type, :metadata => {"x-amz-meta-my-file-name"=>name}})
   end

   def s3_copy(amazon_id,name,s3_bucket,content_type,file_type)
	   logger.info "amazon_id"
	   logger.info amazon_id
       @s3 = AWS::S3.new
	   @s3.buckets[s3_bucket].objects[amazon_id].copy_from(amazon_id,{:acl => :public_read, :content_type => content_type, :content_disposition =>'attachment;filename="'+name+file_type+"\"" ,:metadata => {"x-amz-meta-myfile-name"=>name}})
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
  def assign_to_user (object,object_id)
	  logger.info "in assign_to_user"
    if object == "album"
      @user = User.find(current_user.id)
      @album = Album.find(object_id)
      @album.users << @user
      @album.save
      cookies[:object] = {:expires => 1.year.ago}
      cookies[:song_album_or_event_id] = {:expires => 1.year.ago}
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
        logger.info "in find album"
		artist.albums.uniq.each do |album|
			if album.album_url_slug == url_slug
				@album = album
			end
		end

		logger.info @album
	end




	#finds bucket based on object paramiter.  Used for S3 upload.
	def find_bucket(object)

		if object == "song"
			@bucket = BUCKET
		elsif object == "album"
			@bucket = ALBUM_BUCKET
		elsif object == "image"
			@bucket = IMAGE_BUCKET
		end

	end


	#updates the meta data on s3. Checks to see if song name matches meta name, if not it copies the object in s3 giving it the new name (copy in s3 doesnt allow you to change meta data)
	def send_s3_meta_s3 (song_id,object)


		if object || params[:object_type] == "song"
			@song = Song.find(song_id)

			logger.info("in send_s3_meta")
			logger.info("song name= "+@song.song_name.to_s)
			logger.info("song s3 meta tag= "+@song.s3_meta_tag.to_s)

			if @song.song_name == @song.s3_meta_tag || @song.song_name.nil?

			else


				find_bucket('song')
				s3_copy(@song.s3_id,@song.song_name,@bucket,"audio/mpeg",".mp3")
				logger.info("after s3_copy")
			end

		else
			logger.info "something wrong the the send_s3_meta_s3"
		end
	end

    #sets the layout based on the type of content that is being loaded
	def layout(layout_type)
		#most content.  that is loaded into the artist content area (just content)
		if layout_type.nil? || layout_type.blank?
			@layout = false
			@hook = "#content"
		#when artist page has to be loaded (logo, nave and content)
		elsif layout_type == "artist"
			@layout = "layouts/artist_admin_and_artist_floating_content.html.erb"
			@hook = ".dynamicContent"
		end
	end


  #sets variables and loads forms for image uploads
  def image_upload_prep(artist)

    bk_image_name = "Three_Repeater-"+artist.url_slug+"-"
    @bucket = IMAGE_BUCKET

    @image_save_location = artist_save_image_url(@artist.url_slug)

    logger.info("save image location")
    logger.info(@image_save_location)

    #bk_image_uplosd
    @bk_image_upload = render_to_string('shared/_s3_upload_form_image', :locals => {:image_name => bk_image_name, :image_type => "bk_image", :image_save_url =>@image_save_location}, :layout => false)

    #logo Upload
    @logo_image_upload = render_to_string('shared/_s3_upload_form_image', :locals => {:image_name => bk_image_name, :image_type => "logo", :image_save_url => @image_save_location}, :layout => false)

    #profile image upload
    @profile_image_upload = render_to_string('shared/_s3_upload_form_image', :locals => {:image_name => bk_image_name, :image_type => "profile", :image_save_url => @image_save_location}, :layout => false)

    logger.info "bk form"
    logger.info @bk_image_upload

    logger.info "image upload form"
    logger.info @logo_image_upload


  end


  def save_colour_theme(artist, theme_name)

    @artist = artist
    logger.info "in save colour theme. Theme = "+theme_name.to_s

    if theme_name == "theme_1"

      @artist.profile_layout.p_colour = "#FFFFFF"
      @artist.profile_layout.h1_colour = "#FFFFFF"
      @artist.profile_layout.h2_colour = "#FFFFFF"
      @artist.profile_layout.h3_colour = "#FFFFFF"
      @artist.profile_layout.logo_colour = "#FFFFFF"
      @artist.profile_layout.div_1_colour = "#FFFFFF"
      @artist.profile_layout.nav_text_colour = "#FFFFFF"
      @artist.profile_layout.div_1_background_colour = "#6B6B70"
      @artist.profile_layout.call_to_action_colour = "#E21443"
      @artist.profile_layout.background_colour = "#3D3B42"
      @artist.profile_layout.nav_hover_colour = "#1FB0C5"

    elsif theme_name == "theme_1_inverse"

        @artist.profile_layout.p_colour = "#FFFFFF"
        @artist.profile_layout.h1_colour = "#FFFFFF"
        @artist.profile_layout.h2_colour = "#FFFFFF"
        @artist.profile_layout.h3_colour = "#FFFFFF"
        @artist.profile_layout.logo_colour = "#3D3B42"
        @artist.profile_layout.div_1_colour = "#FFFFFF"
        @artist.profile_layout.div_1_background_colour = "#3D3B42"
        @artist.profile_layout.call_to_action_colour = "#E21443"
        @artist.profile_layout.background_colour = "#FFFFFF"
        @artist.profile_layout.nav_text_colour = "#3D3B42"
        @artist.profile_layout.nav_hover_colour = "#1FB0C5"


    elsif theme_name == "theme_2"

      @artist.profile_layout.p_colour = "#DFF2ED"
      @artist.profile_layout.h1_colour = "#DFF2ED"
      @artist.profile_layout.h2_colour = "#DFF2ED"
      @artist.profile_layout.h3_colour = "#DFF2ED"
      @artist.profile_layout.logo_colour = "#DFF2ED"
      @artist.profile_layout.div_1_colour = "#DFF2ED"
      @artist.profile_layout.div_1_background_colour = "#607B94"
      @artist.profile_layout.call_to_action_colour = "#405F73"
      @artist.profile_layout.background_colour = "#295073"
      @artist.profile_layout.nav_text_colour = "#DFF2ED"
      @artist.profile_layout.nav_hover_colour = "#6D848C"

    elsif theme_name == "theme_3"

      @artist.profile_layout.p_colour = "#FFF9EF"
      @artist.profile_layout.h1_colour = "#FFF9EF"
      @artist.profile_layout.h2_colour = "#FFF9EF"
      @artist.profile_layout.h3_colour = "#FFF9EF"
      @artist.profile_layout.logo_colour = "#FFF9EF"
      @artist.profile_layout.div_1_colour = "#FFF9EF"
      @artist.profile_layout.div_1_background_colour = "#48616C"
      @artist.profile_layout.call_to_action_colour = "#EC4911"
      @artist.profile_layout.background_colour = "#00303E"
      @artist.profile_layout.nav_text_colour = "#FFF9EF"
      @artist.profile_layout.nav_hover_colour = "#7096AD"

    elsif theme_name == "theme_4"

      @artist.profile_layout.p_colour = "#FFFFFF"
      @artist.profile_layout.h1_colour = "#FFFFFF"
      @artist.profile_layout.h2_colour = "#FFFFFF"
      @artist.profile_layout.h3_colour = "#FFFFFF"
      @artist.profile_layout.logo_colour = "#FFFFFF"
      @artist.profile_layout.div_1_colour = "#FFFFFF"
      @artist.profile_layout.div_1_background_colour = "#6F6F6F"
      @artist.profile_layout.call_to_action_colour = "#CD4B3D"
      @artist.profile_layout.background_colour = "#404040"
      @artist.profile_layout.nav_text_colour = "#FFFFF"
      @artist.profile_layout.nav_hover_colour = "#E6E632"


    elsif theme_name == "theme_5"

      @artist.profile_layout.p_colour = "#FFFFFF"
      @artist.profile_layout.h1_colour = "#FFFFFF"
      @artist.profile_layout.h2_colour = "#FFFFFF"
      @artist.profile_layout.h3_colour = "#FFFFFF"
      @artist.profile_layout.logo_colour = "#FFFFFF"
      @artist.profile_layout.div_1_colour = "#FFFFFF"
      @artist.profile_layout.div_1_background_colour = "#5E6A73"
      @artist.profile_layout.call_to_action_colour = "#00ADA9"
      @artist.profile_layout.background_colour = "#293B47"
      @artist.profile_layout.nav_text_colour = "#FFFFF"
      @artist.profile_layout.nav_hover_colour= "#CBFF48"

    elsif theme_name == "theme_6"

      @artist.profile_layout.p_colour = "#F7F6F3"
      @artist.profile_layout.h1_colour = "#F7F6F3"
      @artist.profile_layout.h2_colour = "#F7F6F3"
      @artist.profile_layout.h3_colour = "#F7F6F3"
      @artist.profile_layout.logo_colour = "#F7F6F3"
      @artist.profile_layout.div_1_colour = "#F7F6F3"
      @artist.profile_layout.div_1_background_colour = "#424241"
      @artist.profile_layout.call_to_action_colour = "#CC0015"
      @artist.profile_layout.background_colour = "#000000"
      @artist.profile_layout.nav_text_colour = "#F7F6F3"
      @artist.profile_layout.nav_hover_colour = "#FFD428"


    end


    @artist.profile_layout.save

    logger.info "nav hover colour= " + @artist.profile_layout.nav_hover_colour.to_s

  end






end




