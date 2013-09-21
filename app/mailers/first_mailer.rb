class FirstMailer < ActionMailer::Base
  #include Rails.application.routes.url_helpers
  default from: "no-replay@threerepeater.com"


  def thank_you_download(user,album,artist)
	  logger.info "in thank you download email"
	  @user = user
	  @album = album
	  @artist = artist
	  @url  = 'http://www.threerepeater.com/login'
	  @download_url = "/"+@artist.url_slug+"/album/"+@album.album_url_slug+"/download?redown=true"

	  mail(to: @user.email, subject: 'Your download')
  end
end
