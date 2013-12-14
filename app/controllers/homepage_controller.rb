class HomepageController < ApplicationController
   #before_filter :authenticate_user!

  def index
    @name = 'ted'
	@s3_key = S3_KEY
	@bucket = BUCKET
    render :template => 'shared/homepage'


  end


  def thank_you


    render :template => 'shared/thank_you_sign_up.html.erb'
  end



end
