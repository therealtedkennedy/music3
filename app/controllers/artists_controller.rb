class ArtistsController < ApplicationController
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:css, :social_promo]
  require 'uri'
  # GET /artists
  # GET /artists.xml

  before_filter :authenticate_user!, :except => [:show, :index,:social_promo, :css]

  #changes from default layout to custom layout

  layout "artist_admin", only: [:show, :admin, :update, :social_promo, :pre_delete, :new]



  def index
    @artists = Artist.all
    @artist = Artist.new


    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @artists }

    end
  end

  def css
    searchString = params[:url_slug]
    @artist = Artist.find_by_url_slug(searchString)
    render 'default.css.erb'
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    #@artist = Artist.find(params[:id])
    searchString = params[:url_slug]
    @artist = Artist.find_by_url_slug(searchString)


	#for promo screen.  Shows promo if coming from a Non artist URL, or if some one has clicked on the logo which is tagged with promo = ture param

    #checks to see if the referer exsists, and if it does assigned it to host for logic below
    unless request.referer.nil?
		@host = URI(request.referer).path
		logger.info("path="+@host)
    end

	#checks to see if refering url has the artist path and doen't have promo.  If true doesn't show promo

	if @host.try(:starts_with?,"/"+@artist.url_slug) && !params.has_key?(:promo)
        logger.info("path working")
		#used to ensures the Info menu item is tagged with the selector by adding selector to the div.
		@tag_info = "selected"

	else
		logger.info("show promo")
		@show_promo = "true"
	end



    @playlist = @artist.songs

    artist_social(@artist)

	#sets the layout that will be loaded and the content div that it will be loaded into
	layout(params[:layout])
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @artist }
      format.json {
        render :json => {
            :success => true,
			:"#{@hook}" => render_to_string(
                :action => 'show.html.erb',
                :layout => @layout
            ),
			:"show" => "true",
        }
      }
	end

  end



  # GET /artists/new
  # GET /artists/new.xml
  def new
    @artist = Artist.new


	@form = render_to_string('artists/_form_new_artist.html.erb',:layout => false)

	layout(params[:layout])
    respond_to do |format|
      format.html # new.html.erb
	  format.json {
		  render :json => {
				  :success => true,
				  :".bodyArea" => render_to_string(
						  :action => 'new.html.erb',
						  :layout => "layouts/user.html.erb",
				  ),
				  #show/hides edit screen
				  #:"edit" => "true"
				  #sets object type to user.  Loads Correct
				  :"object_type" => "user"
		  }
	  }
    end
  end

  # GET /artists/1/edit
  def edit
    #@artist = Artist.find(params[:id])
    @artist = Artist.find_by_url_slug(params[:url_slug])
    authorize! :update, @artist
  end

  # POST /artists
  # POST /artists.xml
  def create
    @artist = Artist.new(params[:artist])
    #assigns User

    @user = current_user
    @artist.users << @user

    #creates and assigns layout
    @artist.profile_layout = ProfileLayout.new

    respond_to do |format|
      if @artist.save
        format.html { redirect_to(artist_admin_path(@artist.url_slug)) }
        format.xml { render :xml => @artist, :status => :created, :location => @artist }

      else
        format.html { render :action => "new" }
        format.xml { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end


  end

  # PUT /artists/1
  # PUT /artists/1.xml

  #directing for vanity URL.


  def update
    @artist = Artist.find(params[:id])



   # @file_name = params[:artist][:image].filename
   # @image_location = "/Sites/music3/public/uploads/artist/image/"+@artist.id+"/"+@file_name

	layout("artist")

    respond_to do |format|
      if @artist.update_attributes(params[:artist])

        format.html { redirect_to(artist_admin_path(@artist.url_slug), :notice => 'Artist was successfully updated.') }
        format.xml { head :ok }
		format.json {
			render :json => {
					:success => true,
					:"url" => artist_link_url(@artist.url_slug),
					:admin => true,
			}
		}
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end



  def admin

    @artist = Artist.find_by_url_slug(params[:url_slug])
    authorize! :admin, @artist

	@artist_test="blah"

	image_upload_prep(@artist)

	@form = render_to_string('artists/_form',:layout => false)

	#varable to remove defualt artist loading.  Loads the edit layout insted
	@edit = "true" #see new

	layout(params[:layout])
	respond_to do |format|
		format.html {render :layout => 'artist_admin'}
		format.json {
			render :json => {
					:success => true,
					:"#{@hook}" => render_to_string(
							:action => 'admin.html.erb',
							:layout => @layout,
					),
					:"edit" => "true",
					:"admin-show" => "true",

			}
		}
	end

  end

  #intersitial page, for social promotion.
  def social_promo

	  @artist = Artist.find_by_url_slug(params[:url_slug])

	  #params set with Query strings

	  if params[:object] == "album"
		  @album = Album.find(params[:id])

		  #in application controller
		  album_social(@artist,@album)

	  elsif params[:object] == "song"

		  #in application controller
		  @song = Song.find(params[:id])

		  song_social(@artist,@song)
	  end

	  #overides the album and or song default facebook url.  For the social promo page, you have to like the artist. this is b/c following an artist is like subscribing to their content
	  facebook_url(@artist)

	  respond_to do |format|
		  format.html
		  format.xml
		  format.json {
			  render :json => {
					  :success => true,
					  :"#content" => render_to_string(
							  :action => 'social_promo.html.erb',
							  :layout => false
					  ),
			  }
		  }

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

	  logger.info "bk form"
	  logger.info @bk_image_upload

	  logger.info "image upload form"
	  logger.info @logo_image_upload


  end


  def destroy
    authorize! :destroy, @artist
    @artist = Artist.find(params[:id])
    # searchString  = params[:url_slug]

    #@artist = Artist.find_by_url_slug(searchString)
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to(show_user_path(current_user.id), :notice => 'Artist was successfully Deleted.') }
      format.json { render :json => {}, :status => :ok }
      format.js
	end

  end





    def pre_delete

		@artist = Artist.find_by_url_slug(params[:url_slug])

		 authorize! :destroy, @artist

		#varable to remove defualt artist loading.  Loads the edit layout insted
		@edit = "true" #see new

		respond_to do |format|
			format.html {render :layout => 'artist_admin'}
			format.xml { render :xml => @artists }

		end

	end

	def artist_save_image

    	@artist = Artist.find_by_url_slug(params[:url_slug])



		#build url
        if params[:type] == "bk_image"
			@artist.image = "https://ted_kennedy_image.s3.amazonaws.com/Three_Repeater-"+@artist.url_slug+"-"+params[:file_name]
            logger.info("in bk image")
		elsif params[:type] == "logo"
			@artist.logo = "https://ted_kennedy_image.s3.amazonaws.com/Three_Repeater-"+@artist.url_slug+"-"+params[:file_name]
			logger.info("in logo")
		else
			logger.info("In artist_save_image. Something is up with the image type paramiter coming from the app admin layout")
		end



		logger.info("artist image= "+@artist.image.to_s)
		logger.info("artist logo= "+@artist.logo.to_s)

		respond_to do |f|
			if @artist.save
				f.json {
					render :json => {
							:success => true}
				}
			else
				f.json {
					render :json => {
							:success => false}
				}
			end
		end

	end
end


