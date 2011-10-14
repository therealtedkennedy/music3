class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.xml
  def index
    @artists = Artist.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end

  # GET /artists/1
  # GET /artists/1.xml
  def show
    #@artist = Artist.find(params[:id])
    searchString  = params[:url_slug]
    @artist = Artist.find_by_url_slug(searchString)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @artist }

    end
  end

  # GET /artists/new
  # GET /artists/new.xml
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  # GET /artists/1/edit
  def edit
    #@artist = Artist.find(params[:id])
    searchString  = params[:url_slug]
    @artist = Artist.find_by_url_slug(searchString)
  end

  # POST /artists
  # POST /artists.xml
  def create
    @artist = Artist.new(params[:artist])

    respond_to do |format|
      if @artist.save

        format.html { redirect_to(artist_link_path(@artist.url_slug), :notice => 'Artist was successfully created.') }
        format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.xml

  #directing for vanity URL.


  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to(artist_link_path(@artist.url_slug), :notice => 'Artist was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # adds a song for a specific artist
  def add_song
      #@artist = Artist.find(params[:id])
      @artist = Artist.find_by_url_slug(params[:url_slug])
      @song = Song.new
      @song.artists << Artist.find(@artist.id)
      @song.save

      redirect_to(edit_song_path(@song.id), :notice => 'Song was successfully created.')

    #  respond_to do |format|
     #   format.html # show.html.erb
     #   format.xml  { render :xml => @artist }
   #   end
    end

  # DELETE /artists/1
  # DELETE /artists/1.xml

  # on to something...but too tired to think about it.

  def upload_song
      @song = Song.new(params[:song])
     if params[:artist_id]
       @song.artists << Artist.find(params[:artist_id])
     end

      respond_to do |format|
      if @song.save
          format.html {
          redirect_to(add_song_path(artist.url_slug), :notice => 'Song was successfully created.')
        }
        format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end



  def destroy
    @artist = Artist.find(params[:id])
    # searchString  = params[:url_slug]

    #@artist = Artist.find_by_url_slug(searchString)
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to(artists_path)}
      format.json {render :json => {}, :status => :ok}
    end
  end
end

