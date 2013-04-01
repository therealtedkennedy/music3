class ArtistHomeController < ApplicationController
  def index
    render :template =>'shared/artist_home'
	@bucket = BUCKET
	@s3_key = S3_KEY
  end
end
