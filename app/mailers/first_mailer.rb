class FirstMailer < ActionMailer::Base
  default from: "no-replay@firmex.com"


  def thank_you_download(user,album,artist)
	  logger.info "in thank you download email"
	  @user = user
	  @album = album
	  @artist = artist
	  @url  = 'http://www.threerepeater.com/login'
	  mail(to: @user.email, subject: 'Your download')
  end
end
