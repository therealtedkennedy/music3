class HomepageController < ApplicationController
   #before_filter :authenticate_user!

  def index
    @name = 'ted'
	@s3_key = S3_KEY
	@bucket = BUCKET
    render :template => 'shared/homepage'


   end
end
