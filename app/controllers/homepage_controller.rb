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

  def sign_up

    render :template => 'shared/sign_up.html.erb'

  end

  def support_page

    render :template => 'shared/support_form.html.erb'

  end

  def terms_and_conditions

    render :template => 'shared/terms_and_conditions.html.erb'

  end

  def privacy_policy

    render :template => 'shared/privacy_policy.html.erb'

  end



end
