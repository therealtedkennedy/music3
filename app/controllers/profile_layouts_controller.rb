class ProfileLayoutsController < ApplicationController

	layout "profile_edit_layout", only: [:edit,:css_editor,:edit_song,:edit_album,:profile_albums,:profile_songs]


	def new
		@artist = Artist.find_by_url_slug(params[:url_slug])
		@artist.profile_layout = ProfileLayout.new
		@artist.save
	end

	def edit

    logger.info("in edit")

		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout
		image_upload_prep(@artist)

    @form = render_to_string('profile_layouts/_form',:layout => false)

		render 'artists/show'
		#@profile_layout = ProfileLayout.new
		# @artist.profile_layout = @profile_layout
		# @artist.save


	end



	#edits songs atrributes
	def edit_song



		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout
       # @song = Song.find(params[:song_id])
		find_song(@artist, params[:song_url_slug])

		render 'songs/show'
		#@profile_layout = ProfileLayout.new
		# @artist.profile_layout = @profile_layout
		# @artist.save


	end

	#edits album
	def edit_album

		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout
		find_album(@artist,params[:album_url_slug])

		render 'albums/show'
		#@profile_layout = ProfileLayout.new
		# @artist.profile_layout = @profile_layout
		# @artist.save


  end

  def profile_albums

    @artist = Artist.find_by_url_slug(params[:url_slug])
    @artist = Artist.find_by_url_slug(params[:url_slug])
    @albums = @artist.albums
    @profile_layout = @artist.profile_layout

    render 'albums/index'

  end


  def profile_songs

    @artist = Artist.find_by_url_slug(params[:url_slug])
    @songs = @artist.songs
    @profile_layout = @artist.profile_layout

    render 'songs/index'

  end



	def update

		@artist = Artist.find_by_url_slug(params[:url_slug])

		# @profile_layout = @artist.profile_layout


		respond_to do |format|
			if @artist.profile_layout.update_attributes(profile_params)


			  logger.info "in json"
			  format.html { redirect_to(profile_edit_url(@artist.url_slug)) }
				  format.json {
				 		render :json => {
								:success => true}
						}
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @profile_layout.errors, :status => :unprocessable_entity }
			end
		end
	end

	def css_editor

		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout

	end

	def field_save
		if params[:object] == "artist"
			#field = params[:field_name]
			logger.info "artist"
			@artist = Artist.find_by_url_slug(params[:url_slug])
			@artist[params[:field_name]] = params[:value]
            object = @artist


		elsif params[:object] == "song"

			@artist = Artist.find_by_url_slug(params[:url_slug])
			logger.info "Artist"
			logger.info @artist

			find_song(@artist, params[:slug])
			@song[params[:field_name]] = params[:value]
            object = @song


            logger.info "song info"
			logger.info object

			logger.info "artist"


		elsif params[:object] == "album"
			logger.info "album"
			@artist = Artist.find_by_url_slug(params[:url_slug])
			find_album(@artist,params[:slug])
			@album[params[:field_name]] = params[:value]
			#@album = Song.find_by_url_slug(params[:album_url_slug])
			#@album[params[:field_name]] = params[:value]
			object = @album

    elsif params[:object] == "profile"
      logger.info "profile"
      @artist = Artist.find_by_url_slug(params[:url_slug])

      # @artist.profile_layout[params[:field_name]] = params[:value]

      object = @artist.profile_layout
      strong_params =  profile_params

      logger.info "object ="+object.to_s

		end

		respond_to do |format|

			logger.info "Object"
			logger.info object

			if object.update_attribute(params[:profile_layout][:field_name],params[:profile_layout][:value])
				format.json {
					render :json => {
							:success => true}
				}
			end
		end
	end

 	def css_editor_update
		 @artist = Artist.find_by_url_slug(params[:url_slug])

		 respond_to do |format|
			 if @artist.profile_layout.update_attribute(:profile_css,params[:profile_layout][:profile_css])
				 format.json {
				 	render :json => {
				 			:success => true}
				 }
				 format.html { redirect_to (profile_edit_path(@artist.url_slug)), :notice => 'CSS was successfully updated' }
			 else
				 format.html { render :action => "edit" }
				 format.xml  { render :xml => @profile_layout.errors, :status => :unprocessable_entity }
			 end
		 end


  end

  private


  def profile_params
    # NOTE: Using `strong_parameters` gem
    @user = User.find(current_user.id)

    params.required(:profile_layout).permit(:logo_font,:content_font,:h1_colour,:h2_colour,:h3_colour,:p_colour,:div_1_colour,:div_1_transparency,:div_1_border_colour,:div_1_background_colour,:div_1_border_width,:div_2_colour,:div_2_transparency,:div_2_border_colour,:div_2_background_colour,:div_2_border_width,:url_slug, :value, :field_name)

  end

end
