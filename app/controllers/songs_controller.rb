#Explanation here - http://net.tutsplus.com/tutorials/create-a-simple-music-streaming-app-with-ruby-on-rails/

class SongsController < ApplicationController
  #lists songs called from S3 Server


 before_filter :authenticate_user!,  :except => [:show, :index]



  def index
   #not #nessisary
   @s3_songs = AWS::S3::Bucket.find(BUCKET).objects

    @songs = Song.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artists }
    end
  end

  #not used should delete in production.  Deletes S3 songs from Index
  #def delete (song)
   # if (params[:song])
    #  AWS::S3::S3Object.find(params[:song], BUCKET).delete
     # redirect_to songs_path
 #  else
     #  render :text => "No song was found to delete!"
  #  end
 # end

  #finds song objects, when album and URL slug are given
  def find_song(artist,url_slug)

     artist.songs.uniq.each do |song|
        if song.song_url_slug == url_slug
          @song = song

        else

        end
      end
   end



  def show
    if params[:song_url_slug]
    #@artist = Artist.find(params[:id])
    #@artist = Artist.find_by_url_slug(params[:url_slug])
     @artist = Artist.find_by_url_slug(params[:url_slug])
     find_song(@artist,params[:song_url_slug])



    # @song.artists.uniq.each do |artist|
     #   @artist_slug = artist.url_slug
    # end
        respond_to do |format|
          format.html # show.html.erb
          format.xml  { render :xml => @song }
          format.json {
            render :json => {
               :success => true,
               :"#content" => render_to_string(
               :action => 'songs/show.html.erb',
               :layout => false
               )

            }
          }
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
    #finds the assoicated artist
    @artist = Artist.find(@song.s_a_id)
    authorize! :update, @artist
    #searchString  = params[:url_slug]
    #@artist = Artist.find_by_url_slug(searchString)


     respond_to do |format|
           format.html  #show.html.erb
           format.xml  { render :xml => @song }
           format.js
     end
  end

  def save_amazon_file(amazon_id, mp3file,name,artist)
    authorize! :update, artist
   #patched aw3 object.rb with - http://rubyforge.org/pipermail/amazon-s3-dev/2006-December/000007.html
    if(AWS::S3::S3Object::store(amazon_id, mp3file.read, BUCKET, :access => :public_read,'x-amz-meta-my-file-name'=> name, 'Content-Disposition' => 'attachment;filename='+name+'.mp3'))
      return true;
    else
      return false;
    end
  end


# Updates Artist Info ...not sure if this is used anymore
  def used_to_be_upadate
       @song = Song.find(params[:id])


    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to(song_path(@song.id), :notice => 'Artist was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @artist = Artist.find_by_url_slug(params[:url_slug])
    @song = Song.new
    @artist_id = @artist.id
    @song.s_a_id = @artist.id
    @song.save


    #@song = Song.find(params[:id])
    #@id = @song.id
    #searchString  = params[:url_slug]
    #@artist = Artist.find_by_url_slug(searchString)


     respond_to do |format|
           format.html  #create.html.erb
           format.xml  { render :xml => @song }
           format.js
     end
   end




   def update
    @artist = Artist.find(params[:artist_id])
    authorize! :update, @artist
    @song = Song.find(params[:form_song_id])
    @song.artists <<  @artist
    @s3_test = params[:s3_name]

    @song.update_attributes(params[:song])




   #song s3 key, download link and torrent link
    @song.s3_id= @song.id.to_s + ".mp3"
    #@amazon_id = @song.id.to_s + ".mp3"


    if params[:song].has_key?("s3_name")
      save_amazon_file(@song.s3_id, params[:song][:s3_name],@song.song_name, @artist )


    end

       #if @song.s3_id.blank?
          #@song.s3_id= params[:id].to_s + ".mp3"
         # @song.download_link = download_url_for(@song.s3_id)
          #@song.torrent_link= link_to(torrent_url_for(@song.s3_name))
       #end

      respond_to do |format|
        if @song.update_attributes(@song.s3_id)
          format.html { redirect_to (artist_show_song_path(@artist.url_slug, @song.song_url_slug)), :notice => 'Song was successfully created.' }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @artist.errors, :status => :unprocessable_entity }
        end
      end
    end

  #uploads songs from S3 Server. Not sure if this is used any more.

  def upload
     #@id = params[:song_id]
     #@s3_key = @id+".mp3"

    begin
      AWS::S3::S3Object.store(sanitize_filename(params[:mp3file].original_filename), params[:mp3file].read, BUCKET, :access => :public_read)

    end

    rescue
        render :text => "Couldn't complete the upload"


      respond_to do |format|
         format.js  {render}

      end
  end


 # def download


    #  @song = Song.find_by_song_url_slug(params[:song_url_slug])
    #  @artist =  Artist


    #  @song_file = AWS::S3::S3Object.value(@song.s3_id, BUCKET)
    #  send_file(@song_file,
    #        :filename  =>  @song.song_name+".mp3")

   #    respond_to do |format|
    #       format.html  redirect_to(song_path(@song.id), :notice => 'Song was downloaded.')
    #       format.xml
     #      format.js
    #   end
#  end


    #deletes song info from Model
  def destroy



    @song = Song.find(params[:id])
    @artist = Artist.find(@song.s_a_id)
    authorize! :update, @artist


    @song.destroy



    (@song.s3_id)
    AWS::S3::S3Object.find(@song.s3_id, BUCKET).delete

    respond_to do |format|
      format.html {redirect_to(artist_admin_path(@artist.url_slug))}
      format.json {render :json => {}, :status => :ok}
      format.js
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
