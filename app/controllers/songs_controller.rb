#Explanation here - http://net.tutsplus.com/tutorials/create-a-simple-music-streaming-app-with-ruby-on-rails/

class SongsController < ApplicationController
  #lists songs called from S3 Server
  def index
    @songs = AWS::S3::Bucket.find(BUCKET).objects
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
