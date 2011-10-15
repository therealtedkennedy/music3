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

  def delete
   if (params[:song])
      AWS::S3::S3Object.find(params[:song], BUCKET).delete
      redirect_to songs_path
   else
       render :text => "No song was found to delete!"
    end
  end

  def show
    if params[:song_url_slug]
    #@artist = Artist.find(params[:id])
    #@artist = Artist.find_by_url_slug(params[:url_slug])

     @song = Song.find_by_song_url_slug(params[:song_url_slug])

        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @song }
        end


    else

      @song = Song.find(params[:id])

         respond_to do |format|
           format.html  #show.html.erb
           format.xml  { render :xml => @song }
          end
    end
  end

  def edit

    @song = Song.find(params[:id])
    @id = @song.id

    #searchString  = params[:url_slug]
    #@artist = Artist.find_by_url_slug(searchString)
  end


# Updates Artist Info
  def update
    @song = Song.find(params[:id])
     if @song.s3_name.blank?
        @song.s3_name= @song.id.to_s + ".mp3"
     end

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
     if params[:artist_id]
       @song.artists << Artist.find(params[:artist_id])
     end

    respond_to do |format|
      if @song.save
          format.html {
          redirect_to(songs_path, :notice => 'Song was successfully created.')
        }
        format.xml  { render :xml => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end


  #uploads songs from S3 Server
  def upload
     @id = params[:song_id]
     @s3_key = @id+".mp3"

    begin
      AWS::S3::S3Object.store(@s3_key, params[:mp3file].read, BUCKET, :access => :public_read)
     redirect_to songs_path
    rescue
        #render :text => "Couldn't complete the upload"
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


    # Shows a specific artists song
  def artist_show_song

      #@artist = Artist.find(params[:id])
      searchString  = params[:url_slug]
      @artist = Artist.find_by_url_slug(searchString)
      @song = @artist.song.find.by_url_slug(params[:song_name])

     respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @artist }
      end
    end





  private
  # Internet Explorer work around see - http://net.tutsplus.com/tutorials/create-a-simple-music-streaming-app-with-ruby-on-rails/
  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/,'_')
  end

end
