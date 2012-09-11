class HomepageController < ApplicationController
   #before_filter :authenticate_user!

  def index
    @name = 'ted'
    render :template => 'shared/homepage'
   end
end
