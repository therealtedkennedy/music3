class ArtistsController < ApplicationController
  load_and_authorize_resource
  #skip_load_and_authorize_resource :only => :edit
  # GET /artists
  # GET /artists.xml

  before_filter :authenticate_user!, :except => [:show, :index]

  #changes from default layout to custom layout
  layout "artist_layout", only: [:show, :admin, :update]


  def index
    @artists = Artist.all
    @artist = Artist.new


    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @artists }
    end
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    #@artist = Artist.find(params[:id])
    searchString = params[:url_slug]
    @artist = Artist.find_by_url_slug(searchString)


    @playlist = @artist.songs


    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @artist }
      format.json {
        render :json => {
            :success => true,
            :"#content" => render_to_string(
                :action => 'artists/show.html.erb',
                :layout => false
            ),

		    :"#area" => "hello world"
        }
      }

    end
  end

  # GET /artists/new
  # GET /artists/new.xml
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @artist }
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

        format.html { redirect_to(artist_link_path(@artist.url_slug), :notice => 'Artist was successfully created.') }
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

    respond_to do |format|
      if @artist.update_attributes(params[:artist])

     #   Cloudinary::Uploader.upload(File.open(@image_location),
          #                          :public_id => 'pretty-lights')
        format.html { redirect_to(artist_admin_path(@artist.url_slug), :notice => 'Artist was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # First step in adding song, creates and saves blank song before being passed to the song model
  #def add_song
  #  #@artist = Artist.find(params[:id])
  # @artist = Artist.find_by_url_slug(params[:url_slug])
  # @song = Song.new
  # #assocaites artist and song
  # @song.artists << Artist.find(@artist.id)
  # @song.save

  # redirect_to(new_song_id_path(@song.id))
  #  respond_to do |format|
  #   format.html # show.html.erb
  #   format.xml  { render :xml => @artist }
  #   end

  # DELETE /artists/1
  # DELETE /artists/1.xml
  # end
  # end

  # on to something...but too tired to think about it.

  # def upload_song
  #    @song = Song.new(params[:song])
  #  if params[:artist_id]
  #   @song.artists << Artist.find(params[:artist_id])
  # end

  # respond_to do |format|
  # if @song.save
  #   format.html {
  #   redirect_to(add_song_path(artist.url_slug), :notice => 'Song was successfully created.')
  # }
  # format.xml  { render :xml => @artist, :status => :created, :location => @artist }
  # else
  # format.html { render :action => "new" }
  # format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
  #end
  # end
  # end

  def admin

    @artist = Artist.find_by_url_slug(params[:url_slug])
    authorize! :admin, @artist
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
end


