class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  BUCKET ='ted_kennedy'


  #
  #def after_sign_in_path_for(resource_or_scope)
  #
  #  # stored_location_for(resource) ||
  #  if resource_or_scope.is_a?(User)
  #    # (session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
  #
  #    #(session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
  #    #show_user_path(current_user.id)
  #  else
  #    super
  #  end
  #end
#
#  def after_sign_in_path_for(resource)
#    if(session[:"user.return_to"].nil?)
#       #"/artists"
#      :referrer
#    else
#      session[:"user.return_to"].to_s
#    end
#  end
#end


  # Customize the Devise after_sign_in_path_for() for redirecct to previous page after login

  def after_sign_in_path_for(resource_or_scope)

    case resource_or_scope
    when :user, User
      store_location = session[:return_to]
      clear_stored_location
      (store_location.nil?) ? "/artists" : store_location.to_s
    else
      super
    end
  end




  def order_create (object,token)



    @order = object.orders.build(@order)
    @order.express_token = token
    @order.ip_address = request.remote_ip





    if @order.save
      @order.purchase
       # if @order.purchase
          #redirect_to(album_download_path(@album.al_a_id, @album.id), :notice => 'Artist was successfully updated.')
        # render :action => "success"
      #  else
       #  render :action => "failure"
      #  end
      # else
      #  render :action => 'new'
     end

  end
end




