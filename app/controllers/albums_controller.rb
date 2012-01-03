class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.xml
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
   if params[:album_url_slug]

    @album = Album.find_by_album_url_slug(params[:album_url_slug])
    @artist = Artist.find_by_url_slug(params[:url_slug])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @album }
    end

   else

     @album = Album.find(params[:id])
     @artist = Artist.find(@album.al_a_id)

     respond_to do |format|
       format.html # show.html.erb
       format.xml  { render :xml => @album }
     end

   end
  end

  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new
    @artist = Artist.find_by_url_slug(params[:url_slug])
    @album.al_a_id = @artist.id
    @album.artists << Artist.find(@artist.id)
    @album.save



     respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    @artist = Artist.find(@album.al_a_id)

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
        format.html { redirect_to(@album, :notice => 'Album was successfully created.') }
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

    if params.has_key?(:album_songs)
      @album.songs = Song.find(params[:album_songs][:songs_id])
    else
      @album.songs = []
    end

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to(@album, :notice => 'Album was successfully updated.') }
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

  def download_album



   @album = Album.find(params[:id])
   @artist = Artist.find_by_url_slug(params[:url_slug])


    #Sets Directory Path
    directory_path = "D:/Test Projects/Zipped Files"
    directory_artist_path = directory_path+"/"+@artist.url_slug
    directory = directory_artist_path+"/"+@album.album_url_slug
    zipfile = @album.al_name+".zip"

      #Finds and Makes the Directory

       unless (File.directory?(directory_artist_path))
        Dir.chdir(directory_path)
        Dir.mkdir(@artist.url_slug)
       end

       unless (File.directory?(directory))

         Dir.chdir(directory_artist_path)
         Dir.mkdir(@album.album_url_slug)

        end

         #Saves Songs into Directory
          songs_list = Dir.entries(directory)
          @album.songs.uniq.each do |songs|
            unless songs.song_url_slug.blank?
            name =  songs.song_name+".mp3"

            unless songs_list.include?(name)
            #finds the data
              @song_file = AWS::S3::S3Object.value(songs.s3_id, BUCKET)
                #saves file

              # create the file path
                path = File.join(directory, name)

              # write the file

                 File.open(path, 'wb') { |f| f.write(@song_file) }
             end
           end
          end

      unless (Dir.entries(directory_artist_path).include?(zipfile))
        zip(directory_artist_path,@album.al_name,directory)
      end


    respond_to do |format|
      format.html { redirect_to(albums_url, :notice => 'Album was successfully downloaded.')}
      format.xml  { head :ok }
     end


  end


   # if params[:album_url_slug]
   #  @album = Album.find_by_album_url_slug(params[:album_url_slug])
  # else
  #   @album = Album.find(params[:id])
  # end
   #  @album.songs unque each do |download|



     #end




  def zip (directory_artist_path, album_name,directory)
      require 'rubygems'
      require 'zip/zip'

      puts "Zipping files!"

      file_path = directory
      file_list = Dir.entries(directory)
      file_list.delete(".")
      file_list.delete("..")


      zipfile_name = directory_artist_path+"/"+album_name+".zip"

      Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
        file_list.each do |filename|
          # Two arguments:
          # - The name of the file as it will appear in the archive
          # - The original file, including the path to find it
          zipfile.add(filename, file_path + '/' + filename)
        end
      end
    end
end



