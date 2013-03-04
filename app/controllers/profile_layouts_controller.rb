class ProfileLayoutsController < ApplicationController

	layout "profile_edit_layout", only: [:edit,:css_editor,:edit_song]


	def new
		@artist = Artist.find_by_url_slug(params[:url_slug])
		@artist.profile_layout = ProfileLayout.new
		@artist.save
	end

	def edit

		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout


		render 'artists/show'
		#@profile_layout = ProfileLayout.new
		# @artist.profile_layout = @profile_layout
		# @artist.save


	end

	#edits songs atrributes
	def edit_song

		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout
        @song = Song.find(params[:song_id])

		render 'songs/show'
		#@profile_layout = ProfileLayout.new
		# @artist.profile_layout = @profile_layout
		# @artist.save


	end

	#edits album
	def edit_album

		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout
		@ablum = Song.find(params[:ablum_id])

		render 'albums/show'
		#@profile_layout = ProfileLayout.new
		# @artist.profile_layout = @profile_layout
		# @artist.save


	end



	def update

		@artist = Artist.find_by_url_slug(params[:url_slug])

		# @profile_layout = @artist.profile_layout


		respond_to do |format|
			if @artist.profile_layout.update_attributes(params[:profile_layout])


			  logger.info "in json"
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
			logger.info "song"
			logger.info params[:song_id]
	    	@song = Song.find(params[:song_id])
			@song[params[:field_name]] = params[:value]
            object = @song


            logger.info "song info"
			logger.info object

			logger.info "artist"


		elsif params[:object] == "album"
			logger.info "album"
            @album = Album.find(params[:album_id])
			@album[params[:field_name]] = params[:value]
			#@album = Song.find_by_url_slug(params[:album_url_slug])
			#@album[params[:field_name]] = params[:value]
			object = @album

		end

		respond_to do |format|

			logger.info "Object"
			logger.info object

			if object.save
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

end
