#Explanation here - http://net.tutsplus.com/tutorials/create-a-simple-music-streaming-app-with-ruby-on-rails/

class SongsController < ApplicationController
  #lists songs called from S3 Server
  def index
    @s3_songs = AWS::S3::Bucket.find(BUCKET).objects

    @songs = Song.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end

  def show
      @song = Song.find(params[:id])

      respond_to do |format|
        format.html  #show.html.erb
        format.xml  { render :xml => @song }
      end
    end

    def edit
    @song = Song.find(params[:id])
    #searchString  = params[:url_slug]
    #@artist = Artist.find_by_url_slug(searchString)
  end

  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to(song_path :notice => 'Artist was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end

  def create
    @song = Song.new(params[:song])

    respond_to do |format|
      if @song.save

        format.html { redirect_to(songs_path, :notice => 'Artist was successfully created.') }
        format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end


  #uploads songs from S3 Server
  def upload
    begin
      AWS::S3::S3Object.store(sanitize_filename(params[:mp3file].original_filename), params[:mp3file].read, BUCKET, :access => :public_read)
      redirect_to root_path
    rescue
        render :text => "Couldn't complete the upload"
    end

  end
    #deletes song info from Model
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html {redirect_to(songs_path)}
      format.json {render :json => {}, :status => :ok}
      #format.xml  { head :ok }
    end
  end

  #delets songs of s3 server

  def delete
    if(params[:song])
      AWS::S3::S3Object.find(params[:song], BUCKET).delete
      redirect_to root_path
    else
      render :text => "No song was found to delete!"
    end
  end

  private
  # Internet Explorer work around see - http://net.tutsplus.com/tutorials/create-a-simple-music-streaming-app-with-ruby-on-rails/
  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/,'_')
  end

end
