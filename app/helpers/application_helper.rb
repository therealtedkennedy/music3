module ApplicationHelper
  #defines bucket for Amazons S3 Servers
  BUCKET ='ted_kennedy'

  def download_url_for(song_key)
	 @song_url = "https://s3.amazonaws.com/"+BUCKET+"/"+song_key
  end

  def torrent_url_for(song_key)
    download_url_for(song_key) + "?torrent"
  end



end
