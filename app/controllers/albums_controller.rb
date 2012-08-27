class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.xml


  #changes from default layout to custom layout
  layout "artist_layout", only: [:show, :edit]

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
    find_album(@artist,params[:album_url_slug])
    @download_url = album_download_url(@album.album_url_slug, @album.id)


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
      format.json {
        render :json => {
           :success => true,
           :"#content" => render_to_string(
           :action => 'albums/show.html.erb',
           :layout => false
           )

        }
      }



   end
  end

  #finds album objects, when only album url slug is given
  def find_album(artist,url_slug)

     artist.albums.uniq.each do |album|
        if album.album_url_slug == url_slug
          @album = album
        end
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
  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])

    respond_to do |format|
      if @album.save
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

    if params.has_key?(:album_songs)
      @album.songs = Song.find(params[:album_songs][:songs_id])
    else
      @album.songs = []
    end

    respond_to do |format|
      if @album.update_attributes(params[:album])
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

    #Sets Directory Path






    directory_path = "C:/Sites/Zipped"
    #directory_path = "#{Rails.root}/tmp/#{Process.pid}_mp3"
    directory_artist_path = directory_path+"/"+@artist.url_slug
    directory = directory_artist_path+"/"+@album.album_url_slug
    zipfile = @album.al_name+".zip"

    #Finds and Makes the Directory

   # unless (File.directory?(directory_artist_path))
     # Dir.chdir(directory_path)
     # Dir.mkdir(@artist.url_slug)
   # end

   # unless (File.directory?(directory))

   #   Dir.chdir(directory_artist_path)
    #  Dir.mkdir(@album.album_url_slug)

   # end
    FileUtils.mkdir_p directory

    #Saves Songs into Directory
    songs_list = Dir.entries(directory)
    @album.songs.uniq.each do |songs|
      unless songs.song_url_slug.blank?
        name =  songs.song_name+".mp3"

        unless songs_list.include?(name)
          #finds the data
          @song_file = AWS::S3::S3Object.value(songs.s3_id, BUCKET)
          logger.info "Song downlaoded from s3"
          #saves file

          # create the file path
          path = File.join(directory, name)
          logger.info  "File Created"
          # write the file

          File.open(path, 'wb') { |f| f.write(@song_file) }


          #test if file is being written
          #send_file(path,
           # :filename  => name)

        end
      end
    end

    unless (Dir.entries(directory_artist_path).include?(zipfile))
      zip(directory_artist_path,@album.al_name,directory)
      logger.info "Zipped"
      file_list = Dir.entries(directory_artist_path)
      puts file_list

    end

    send_file(directory_artist_path+"/"+zipfile,
              :filename  =>  @album.al_name+".zip")



    #checks to see if album has been redownloaded already trough the redown param and by passes paykey, orders and assign ablum to user
    if params[:redown]=="true" or @album.al_amount.nil? or @album.pay_type == "free"

    else
      #creates an oder.  Might be able to make it into its own app controller
      if cookies[:paykey].to_s.blank?

        order_create(@album,params[:token])

      else

        order_create(@album, cookies[:paykey] )
      end
      # deletes the download cookie so that muliple downloads won't happen
      cookies[:next_step] = {:expires => 1.year.ago}
      #Deletes the pay key for tranactions
      cookies[:paykey] = {:expires => 1.year.ago}

      #checks if user is signed in. If signed in assigns user found in application controller
      if user_signed_in?
        assign_to_user("album",@album.album_url_slug)
      end
    end
  end





  def zip (directory_artist_path, album_name,directory)
    require 'rubygems'
    require 'zip/zip'
    require 'zip/zipfilesystem'

    puts "Zipping files!"

    file_path = directory
    file_list = Dir.entries(directory)
    file_list.delete(".")
    file_list.delete("..")
    zipfile_name = directory_artist_path+"/"+album_name+".zip"

    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      file_list.each do |filename|
        puts filename
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        something = zipfile.add(filename, file_path + '/' + filename)
        puts "This is"
        puts something

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

end



