class ProfileLayoutsController < ApplicationController


  before_filter :authenticate_user!

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

        font_size_save(@artist, @artist.profile_layout.p_size )

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

	def field_update

      @artist = Artist.find_by_url_slug(params[:url_slug])

      authorize! :admin, @artist

      strong_params =  profile_params

      #saves font size

      logger.info "profile layout feild name ="+params[:field][:field_name].to_s

      if params[:field][:field_name] == "p_size"


         logger.info "p_size ="+params[:field][:value].to_s
         font_size_save(@artist, params[:field][:value] )


      elsif params[:field][:field_name] == "colour_theme"

        #sets colour theme

         logger.info "colour_theme="+params[:field][:value].to_s
         save_colour_theme(@artist, params[:field][:value] )


      else


        @white_list = ["logo_font","content_font","h1_colour","h2_colour","h3_colour","p_colour","div_1_colour","div_1_transparency","div_1_border_colour","div_1_background_colour","div_1_border_width","div_2_colour","div_2_transparency","div_2_border_colour","div_2_background_colour","div_2_border_width"]

        if @white_list.include?(params[:field][:field_name])


          @artist.profile_layout.update_attribute(params[:field][:field_name],params[:field][:value])


        else

          logger.info "**************************Profile attribute not white listed.  Please add to white list*************"


        end





      end


    respond_to do |format|


			format.json {
				render :json => {
				:success => true}
			}

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

  def font_size_save(artist, p_size)

    logger.info "in font save. p_size ="+p_size.to_s

    @artist = artist

    @artist.profile_layout.h2_size = (p_size.to_i * 2.142857).round
    @artist.profile_layout.h3_size = (p_size.to_i * 1.2857).round
    @artist.profile_layout.p_size = p_size

    @artist.profile_layout.save

  end

  def save_colour_theme(artist, theme_name)

    @artist = artist

    if theme_name = "theme_1"

      @artist.profile_layout.p_colour = "#FFFFFFF"
      @artist.profile_layout.h1_colour = "#FFFFFFF"
      @artist.profile_layout.h2_colour = "#FFFFFFF"
      @artist.profile_layout.h3_colour = "#FFFFFFF"
      @artist.profile_layout.logo_colour = "#FFFFFF"
      @artist.profile_layout.div_1_colour = "#3D3B42"
      @artist.profile_layout.call_to_action_colour = "#E21443"
      @artist.profile_layout.background_colour = "#3D3B42"
      @artist.nav_hover_colour = "#1FB0C5"


    elsif theme_name = "theme_2"

      @artist.profile_layout.p_colour = "#FFF9EF"
      @artist.profile_layout.h1_colour = "#FFF9EF"
      @artist.profile_layout.h2_colour = "#FFF9EF"
      @artist.profile_layout.h3_colour = "#FFF9EF"
      @artist.profile_layout.logo_colour = "#FFF9EF"
      @artist.profile_layout.div_1_colour = "#A8BFBD"
      @artist.profile_layout.call_to_action_colour = "#EC4911"
      @artist.profile_layout.background_colour = "#C1D1DE"
      @artist.nav_hover_colour = "#1FB0C5"

    elsif theme_name = "theme_3"

      @artist.profile_layout.p_colour = "#DFF2ED"
      @artist.profile_layout.h1_colour = "#DFF2ED"
      @artist.profile_layout.h2_colour = "#DFF2ED"
      @artist.profile_layout.h3_colour = "#DFF2ED"
      @artist.profile_layout.logo_colour = "#DFF2ED"
      @artist.profile_layout.div_1_colour = "#C1D1DE"
      @artist.profile_layout.call_to_action_colour = "#405F73"
      @artist.profile_layout.background_colour = "#00303E"
      @artist.nav_hover_colour = "#7096AD"

    elsif theme_name = "theme_4"

    @artist.profile_layout.p_colour = "#FFFFFF"
    @artist.profile_layout.h1_colour = "#FFFFFF"
    @artist.profile_layout.h2_colour = "#FFFFFF"
    @artist.profile_layout.h3_colour = "#FFFFFF"
    @artist.profile_layout.logo_colour = "#FFFFFF"
    @artist.profile_layout.div_1_colour = "#BFBFBF"
    @artist.profile_layout.call_to_action_colour = "#D9302E"
    @artist.profile_layout.background_colour = "#404040"
    @artist.nav_hover_colour = "#E6E632"


    elsif theme_name = "theme_5"

      @artist.profile_layout.p_colour = "#FFFFFF"
      @artist.profile_layout.h1_colour = "#FFFFFF"
      @artist.profile_layout.h2_colour = "#FFFFFF"
      @artist.profile_layout.h3_colour = "#FFFFFF"
      @artist.profile_layout.logo_colour = "#FFFFFF"
      @artist.profile_layout.div_1_colour = "#5F7A87"
      @artist.profile_layout.call_to_action_colour = "#D9302E"
      @artist.profile_layout.background_colour = "#293B47"
      @artist.nav_hover_colour= "#CBFF48"

    elsif theme_name = "theme_6"

      @artist.profile_layout.p_colour = "#F7F6F3"
      @artist.profile_layout.h1_colour = "#F7F6F3"
      @artist.profile_layout.h2_colour = "#F7F6F3"
      @artist.profile_layout.h3_colour = "#F7F6F3"
      @artist.profile_layout.logo_colour = "#F7F6F3"
      @artist.profile_layout.div_1_colour = "#5F7A87"
      @artist.profile_layout.call_to_action_colour = "#D9302E"
      @artist.profile_layout.background_colour = "#000000"
      @artist.nav_hover_colour = "#FFD428"


    end




  end




  private


  def profile_params
    # NOTE: Using `strong_parameters` gem
    @user = User.find(current_user.id)

    params.required(:field).permit(:logo_font,:content_font,:h1_colour,:h2_colour,:h3_colour,:p_colour,:div_1_colour,:div_1_transparency,:div_1_border_colour,:div_1_background_colour,:div_1_border_width,:div_2_colour,:div_2_transparency,:div_2_border_colour,:div_2_background_colour,:div_2_border_width,:url_slug,:field_name,:value)

  end



end
