module ApplicationHelper
  #defines bucket for Amazons S3 Servers
  #Amazon buckets
  #Change in Application Controller as well!!!  YES! YOUR AN IDIOT FOR NOT READING THIS THE FIRST TIME!
  if Rails.env.production?
    #Change in Application Controller as well!!!  YES! YOUR AN IDIOT FOR NOT READING THIS THE FIRST TIME!
    BUCKET ='production_songs'
    ALBUM_BUCKET = 'production_albums'
    IMAGE_BUCKET = 'production_images_1'

  else
    #Change in Application Controller as well!!!  YES! YOUR AN IDIOT FOR NOT READING THIS THE FIRST TIME!
    BUCKET ='ted_kennedy'
    ALBUM_BUCKET = 'ted_kennedy_album'
    IMAGE_BUCKET = 'ted_kennedy_image'

  end

  def download_url_for(song_key)
    @song_url = "https://s3.amazonaws.com/"+BUCKET+"/"+song_key

  end

  def torrent_url_for(song_key)
    download_url_for(song_key) + "?torrent"
  end


end
