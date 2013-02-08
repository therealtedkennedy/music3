class AlbumCodeController < ApplicationController

 def new
   @album_code = AlbumCode.new
   @album_code.save
  # @album = (album)



 end


 def create

    @album = Album.find(params[:id])


    @number = params[:to_create].to_i
    @number.times do
      @code = @album.album_codes.build
      @code.album_code = SecureRandom.hex(3)
      @code.save
    end

  respond_to do |format|
        format.html { redirect_to(album_create_code_path(@album.artists,@album.id), :notice => 'Codes were successfully generated.') }
        #format.xml  { head :ok }
   end
 end

 def show

  @album = Album.find(params[:id])




   @times = 0
  #  if @album.album_codes.exists?

	respond_to do |format|
		format.html
		format.csv { send_data @album.album_codes.to_csv_3, :filename => @album.al_name+"-Download Codes.csv"}
	end

  end

end
