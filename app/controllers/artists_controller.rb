class ArtistsController < ApplicationController
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:css, :social_promo, :create]
  require 'uri'
  # GET /artists
  # GET /artists.xml

  before_filter :authenticate_user!, :except => [:show, :index,:social_promo, :css]

  #changes from default layout to custom layout

  layout "artist_admin", only: [:show, :admin, :update, :social_promo, :pre_delete,  :edit,:index]



  def index
    @artists = Artist.all

    if Artist.exists?(1)
      @artist = Artist.find(1)
    elsif Artist.find_by_url_slug("tedkennedy").nil?
      @artist = Artist.find_by_url_slug("pearljam")
    else
      @artist = Artist.find_by_url_slug("tedkennedy")
    end


    @artist.image = "../assets-public/images/pages/welcome/records_shelves_trans_40.png"


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

	  #new loads the new page, which the user gives the artist name, then it goes to create which creates the artist object.
	  #then it goes to edit which allow the user to fill in the artist information. Then goes to update where artist info is updated
    @artist = Artist.new
    @artist.profile_layout = ProfileLayout.new




	@form = render_to_string('artists/_form_new_artist.html.erb',:layout => false)
  logger.info(@form)

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
  #edit only loaded after a new artist is created from the artist new page
  #called by the the create controller
  #different from admin bc it is only on create.
  #it exists to that the text in the view can be changed to guide the user through the create process
  def edit


    admin_edit_prep

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

  # POST /artists
  # POST /artists.xml
  def create
    logger.info("in create")

    @artist = Artist.new(artist_params)
    #assigns User



    logger.info("Artist = "+@artist.to_s)
    logger.info("artist name= "+@artist.name)


    @user = current_user
    @artist.users << @user




    #creates and assigns layout
    @artist.profile_layout = ProfileLayout.new



    @form = render_to_string('artists/_form',:layout => false)




      if @artist.save(validate: false)

        redirect_to(edit_artist_path(@artist.url_slug))


      else
           respond_to do |format|

            format.html { render :action => "new", notice => 'Error saving artist. Please try again. If this happening often please contact support '  }
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
      if @artist.update_attributes(artist_params)
        image_upload_prep(@artist)
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

  admin_edit_prep

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

  #preps admin and edit forms. They redirect to diffrent pages, but use the same form.
  def admin_edit_prep

    @artist = Artist.find_by_url_slug(params[:url_slug])
    authorize! :admin, @artist

    @artist_test="blah"

    image_upload_prep(@artist)

    @form = render_to_string('artists/_form',:layout => false)

    #varable to remove defualt artist loading.  Loads the edit layout insted
    @edit = "true" #see new

    layout(params[:layout])



  end

  #intersitial page, for social promotion.


  def social_promo

	  @artist = Artist.find_by_url_slug(params[:url_slug])

	  #params set with Query strings

	  if params[:object] == "album"
		  @album = Album.find(params[:song_album_or_event_id])

      @object_name = @album.al_name
      @promo_url = artist_show_album_url(@artist.url_slug,@album.album_url_slug)
      @object_image = @album.art

      @album

		  #in application controller
		  album_social(@artist,@album)

	  elsif params[:object] == "song"

		  #in application controller
		  @song = Song.find(params[:song_album_or_event_id])

      @object_name = @song.song_name
      @promo_url = artist_show_song_url(@artist.url_slug,@song.song_url_slug)
      @object_image = @song.image

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

    logger.info("In artist_save_image image bucket = "+IMAGE_BUCKET)

		#build url
    if params[:type] == "bk_image"
			@artist.image = "https://"+IMAGE_BUCKET+".s3.amazonaws.com/Three_Repeater-"+@artist.url_slug+"-"+params[:file_name]
      logger.info("in bk image")
      @artist.update_column(:image,@artist.logo)
		elsif params[:type] == "logo"
			@artist.logo = "https://"+IMAGE_BUCKET+".s3.amazonaws.com/Three_Repeater-"+@artist.url_slug+"-"+params[:file_name]
			logger.info("in logo")
      @artist.update_column(:logo,@artist.logo)

    elsif params[:type]=="profile"
      @artist.profile_image = "https://"+IMAGE_BUCKET+".s3.amazonaws.com/Three_Repeater-"+@artist.url_slug+"-"+params[:file_name]
      @artist.update_column(:profile_image,@artist.profile_image)

    else
			logger.info("In artist_save_image. Something is up with the image type paramiter coming from the app admin layout")
		end


		logger.info("artist image= "+@artist.image.to_s)
		logger.info("artist logo= "+@artist.logo.to_s)
    logger.info("artist profile= "+@artist.profile_image)

		respond_to do |f|
				f.json {
					render :json => {
							:success => true}
				}
    end

	end
end

private

def artist_params
  # NOTE: Using `strong_parameters` gem
  @user = User.find(current_user.id)

  params.required(:artist).permit(:name,:logo_toggle,:pay_pal,:twitter_name,:social_title,:fb_page_url,:city,:province,:country,:influence,:bio,:contact_info,:contact_info,:date_founded)

end

def artist_create_params
  # NOTE: Using `strong_parameters` gem

    params.require(:artist).permit(:name)

end

