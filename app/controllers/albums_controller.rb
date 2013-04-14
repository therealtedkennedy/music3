class AlbumsController < ApplicationController

  # GET /albums
  # GET /albums.xml


  #changes from default layout to custom layout
  layout "artist_layout", only: [:show]




  def index
    @albums = Album.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.xml
  def show
    params[:album_url_slug]


    @artist = Artist.find_by_url_slug(params[:url_slug])


	#Finds Album.  In application Controller

    find_album(@artist,params[:album_url_slug])
	logger.info "album"
	logger.info @album

    @download_url = album_download_url(@album.album_url_slug, @album.id)

     album_social(@artist,@album)



	#------------------------------------------------


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
      format.json {
        render :json => {
           :success => true,
           :"#content" => render_to_string(
           :action => 'show.html.erb',
           :layout => false
           )

        }
      }



   end
  end



  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new
    @artist = Artist.find_by_url_slug(params[:url_slug])
    authorize! :update, @artist
    @album.al_a_id = @artist.id
    @album.artists << Artist.find(@artist.id)
    @album.save
    #creates blank song ids?
    @song_ids = []
	@meta_update_url = "nohting"


     respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    @artist = Artist.find(@album.al_a_id)
    authorize! :update, @artist

   #For Check Box - Creates an Array of song Id's for a particular artist to select songs that already exsist
    @song_ids = Array.new
    @album.songs.uniq.each do |s|
      @song_ids << s.id
    end

	render :layout => 'artist_admin'

  end



  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])
    @artist = Artist.find_by_url_slug(params[:url_slug])


    respond_to do |format|
      if @album.save
        if AWS::S3::S3Object.exists? @album.id.to_s, ALBUM_BUCKET
        else
          zip_album(@artist,@album)
        end
        format.html { artist_show_album_path(@album , :notice => 'Album was successfully created.') }
        format.xml  { render :xml => @album, :status => :created, :location => @album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
   #  params[:album_songs][:songs_id] ||= []
    @album = Album.find(params[:id])
    @artist = Artist.find_by_url_slug(params[:url_slug])
    authorize! :update, @artist

	#used check to see if albums songs have changed

    if params.has_key?(:album_songs)
      @album.songs = Song.find(params[:album_songs][:songs_id])
    else
      @album.songs = []
    end

    respond_to do |format|
      if @album.update_attributes(params[:album])
        #zips and creates and album in S3

        #checks to see the albums songs have changed.
        #if AWS::S3::S3Object.exists? @album.id.to_s, ALBUM_BUCKET
		if  params[:album_songs].to_s == @album.album_songs.to_s
		   logger.info "album_songs true"
		else
		   logger.info "in zip album"
           zip_album(@artist,@album)
		   @album.update_attribute(:album_songs, params[:album_songs].to_s)
        end

        format.html { redirect_to(artist_show_album_path(@artist.url_slug, @album.album_url_slug), :notice => 'Album was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(albums_url) }
      format.xml  { head :ok }
    end
  end


  def album_code_download

    @artist = Artist.find_by_url_slug(params[:url_slug])
    @url_slug = params[:url_slug]
    authorize! :create, @artist

  end


  #creates a zip file for the album.  Stores it in S3
  def zip_album (artist, album)
    #sets the directory path the album is going to be stored in
    #directory_path = "C:/Sites/Zipped"  (for testing)
    directory_path = "#{Rails.root}/tmp/#{Process.pid}_mp3"
    directory_artist_path = directory_path+"/"+artist.url_slug
    #sets date to avoid duplicates if changes are made to album songs
	date = Time.now.to_s(:number)
    directory = directory_artist_path+"/"+album.album_url_slug+"_"+date

    #zipfile = album.album_url_slug+".zip"
    no_zip =   album.album_url_slug

    #deletes the directory if it already exsists.  Means something has changed.
	#if File.directory?(directory)
		#File.delete(directory)
	#end

    #Makes the Directory
    FileUtils.mkdir_p directory

    #Saves Songs into album Directory

    logger.info "before writing loop"
    album.songs.uniq.each do |songs|
      unless songs.song_url_slug.blank?
        name =  songs.song_name+".mp3"
        path = File.join(directory, name)

        logger.info "before file Open"
        File.open(path,'wb') do |file|
        s3 = AWS::S3.new
		s3.buckets[BUCKET].objects[songs.s3_id].read do |chunk|
          #AWS::S3::S3Object.stream(songs.s3_id, BUCKET) do |chunk| (changed)
            file.write chunk
            #logger.info "after write"
          end
        end
        logger.info "after File open"
      end
    end

    logger.info "After writing loop before zip"


    #zips the file
	#Sets Zip file name.  Date is included to avoid duplicates when changing songs in ablums


	zipfile_name = album.album_url_slug+"_"+date+".zip"
	#sets Zip File Location
	zipfile_location = directory_artist_path+"/"+zipfile_name

	zip(zipfile_location,directory)
    logger.info "after zip method"
    file_list = Dir.entries(directory_artist_path)

    #logger stuff
    logger.info "Artist Zip File Directory after zip"
    logger.info file_list
    song_list = Dir.entries(directory)
    logger.info "List of Song Files after zip"
    logger.info song_list
    # end

    #logger stuff
    logger.info "before send file, zip file name"
    logger.info zipfile_name
    logger.info "file size"


    #logger stuff
    size = File.size(zipfile_location)
    logger.info size

    #Saves to S3

	#checks if it already exsists and deletes it if i does.  For when album is updated with songs
	if AWS::S3::S3Object.exists? @album.id.to_s, ALBUM_BUCKET
		logger.info "in delete...would be amazing if this happend"
	   AWS::S3::S3Object.delete @album.id.to_s, ALBUM_BUCKET
	end

	s3_file = File.open(zipfile_location)
	save_amazon_file(album.id.to_s, s3_file,album.al_name, @artist, ALBUM_BUCKET )


  end


  #downloads album and creates an order (if nessiary)

  def download_album


    if(params.has_key?(:album_url_slug))

      @artist = Artist.find_by_url_slug(params[:url_slug])
      find_album(@artist,params[:album_url_slug])



      #authorize! :create, @artist
    else
      @album = album
      @artist = artist
      # authorize! :create, @artist

    end
    #checks to see if album object exsists in S3.
    if AWS::S3::S3Object.exists? @album.id.to_s, ALBUM_BUCKET
      #downloads the album
      album_s3_url = AWS::S3::S3Object.url_for(@album.id.to_s, ALBUM_BUCKET, :authenticated => false)
      redirect_to album_s3_url

	else
	 #zips the file and uploads to S3
     zip_album(@artist,@album)
	 #downloads the album
     album_s3_url = AWS::S3::S3Object.url_for(@album.id.to_s, ALBUM_BUCKET, :authenticated => false)
     redirect_to album_s3_url

    end

    #checks to see if album has been redownloaded already trough the redown param and by passes paykey, orders and assign ablum to user
    if params[:redown]=="true" or @album.al_amount.nil? or @album.pay_type == "free"

    else
      #creates an oder.  Might be able to make it into its own app controller
      if cookies[:paykey].to_s.blank?

        order_create(@album,params[:token])

      else

        order_create(@album, cookies[:paykey] )
      end

      #checks if user is signed in. If signed in assigns user found in application controller
      if user_signed_in?
        assign_to_user("album",@album.album_url_slug)
      end
	end

	# deletes the download cookie so that muliple downloads won't happen
	cookies[:next_step] = {:expires => 1.year.ago}
	#Deletes the pay key for tranactions
	cookies[:paykey] = {:expires => 1.year.ago}
  end




  #zips the actual file comes from Zip album
  def zip (zipfile_location,directory)
    require 'rubygems'
    require 'zip/zip'
    require 'zip/zipfilesystem'

    logger.info "Before Zipping files inside Zip Method"

    file_path = directory
    file_list = Dir.entries(directory)
    file_list.delete(".")
    file_list.delete("..")
    #zipfile_name = directory_artist_path+"/"+zip_file_name+".zip"



    Zip::ZipFile.open(zipfile_location, Zip::ZipFile::CREATE) do |zipfile|
      file_list.each do |filename|

        logger.info "In Zip file loop.  Below Zip File name"
        logger.info filename
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        something = zipfile.add(filename, file_path + '/' + filename)
        logger.info "After Zip File Add"


      end
    end
  end


  def album_code_find
    @artist = Artist.find_by_url_slug(params[:url_slug])

    if @code =  AlbumCode.find_by_album_code(params[:code])

      redirect_to(album_download_path(@artist.url_slug,@code.code_album_id))

    else
        respond_to do |format|
           format.html { redirect_to(album_code_download_path(@artist.url_slug), :notice => "Code not found please try again.") }
           format.xml  { head :ok }
        end
    end


  end

  #Saves S3 Album..should be universal in the applications controller.
  def save_amazon_file(amazon_id, zipfile,name,artist,s3_bucket)
    authorize! :update, artist
    #patched aw3 object.rb with - http://rubyforge.org/pipermail/amazon-s3-dev/2006-December/000007.html
    if(AWS::S3::S3Object::store(amazon_id, zipfile.read, s3_bucket, :access => :public_read,'x-amz-meta-my-file-name'=> name, 'Content-Disposition' => 'attachment;filename='+name+'.zip'))
      return true;
    else
      return false;
    end
  end

	#creates album playlist
	def album_play_list_create
        @artist = Artist.find_by_url_slug(params[:url_slug])
		@album = Album.find_by_album_url_slug(params[:album_url_slug])

		@songs_for_playlist = Array.new
		#@songs_for_playlist << "{
		#				title:\"Kinda Toney\",
		#				mp3:\"http://s3.amazonaws.com/ted_kennedy/37.mp3\"
		#	        	}"
		#@songs_for_playlist	<<	"{
		#						title:\"Hidden\",
		#						mp3:\"http://www.jplayer.org/audio/mp3/Miaow-02-Hidden.mp3\"
		#				}"
		@album.songs.uniq.each do |songs|
			unless songs.song_url_slug.blank?
				@song_name = songs.song_name
				@download = AWS::S3::S3Object.url_for(songs.s3_id, BUCKET, :authenticated => false)
                #Preps playlist for Json
				@songs_for_playlist << {:title => @song_name, :mp3 => @download, :artist => @artist.name, :songID => songs.id}

			end
		end

		respond_to do |format|
			        format.html
					format.json {
						render :json => {
								:success => true,
								:playlist => @songs_for_playlist,
						}


					}
		end

	end


end



