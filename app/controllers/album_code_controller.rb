class AlbumCodeController < ApplicationController

	layout "artist_admin", only: [:show]

 def new
   @album_code = AlbumCode.new
   @album_code.save
  # @album = (album)



 end


 def create

    @album = Album.find(params[:id])
    @artist = Artist.find_by_url_slug(params[:url_slug_hidden])

	#used to define total number of codes created
	@number_of_codes = @artist.number_of_codes

    #check to see if the total number codes is above the limit. CODE_LIMIT set in application controller
	if @number_of_codes <= CODE_LIMIT
        #generates codes
		@number = params[:to_create].to_i
		@number.times do
		  #counts the number of codes generated
		  @number_of_codes = @number_of_codes+1
		  #actually creates the code
		  @code = @album.album_codes.build
		  @code.album_code = SecureRandom.hex(3)
		  @code.save
		end

		#saves the number of codes created on the artist object
		@artist.update_attribute(:number_of_codes, @number_of_codes)

		#sets the notice
		@notice = "Codes were successfully created"

	else
		#sets the notice if the total number is over
		@notice = "You are over you limit please upgrade"
    end

	#respond_to do |format|
	#
	#	format.html { flash[:notice] = @notice
	#	redirect_to(album_create_code_path(@artist.url_slug,@album.id))}
	#	#format.xml  { head :ok }
	#end

	respond_to do |format|
		format.html { flash[:notice] = @notice
			redirect_to(album_create_code_path(@artist.url_slug,@album.id))}
		format.xml { render :xml => @artist }
		format.csv { send_data @album.album_codes.to_csv_3, :filename => @album.al_name+"-Download Codes.csv"}
		format.json {
			render :json => {
					:success => true,
					:"url" => album_create_code_url(@artist.url_slug,@album.id),
			        :edit => "true",
			}
		}
	end

 end

 def show

	  @album = Album.find(params[:id])
	  @artist = Artist.find_by_url_slug(params[:url_slug])
	  @codes_left = CODE_LIMIT - @artist.number_of_codes
	  @edit = "true"


	   @times = 0

	  @form = render_to_string('album_code/_form',:layout => false)
	  #  if @album.album_codes.exists?

		#respond_to do |format|
		#	format.html
		#	format.csv { send_data @album.album_codes.to_csv_3, :filename => @album.al_name+"-Download Codes.csv"}
		#end

	  respond_to do |format|
		  format.html {render :layout => 'artist_admin'}
		  format.xml { render :xml => @artist }
		  format.csv { send_data @album.album_codes.to_csv_3, :filename => @album.al_name+"-Download Codes.csv"}
		  format.json {
			  render :json => {
					  :success => true,
					  :".miniPage" => render_to_string(
							  :action => 'show.html.erb',
							  :layout => false
					  ),
					  :"edit" => "true"
			  }
		  }
	  end

 end


  def album_codes_csv

    @album = Album.find(params[:id])

    respond_to do |format|

      format.csv { send_data @album.album_codes.to_csv_3, :filename => @album.al_name+"-Download Codes.csv"}

    end

  end

end
