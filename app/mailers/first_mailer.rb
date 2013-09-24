class FirstMailer < ActionMailer::Base
  #include Rails.application.routes.url_helpers
  default from: "no-replay@threerepeater.com"


  def thank_you_download(user,album,artist)
	  logger.info "in thank you download email"
	  @user = user
	  @album = album
	  @artist = artist
	  @user_url  = "http://www.threerepeater.com/users/show/"+user.id.to_s
	  @download_url = "http://www.threerepeater.com/"+@artist.url_slug+"/album/"+@album.album_url_slug+"/download?redown=true"


	  mail :subject => "Gotta see it to belive it",
		   :to      => user.email,
		   :from    => "no-replay@threerepeater.com"
  end
end
