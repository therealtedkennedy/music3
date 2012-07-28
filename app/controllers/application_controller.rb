class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  BUCKET ='ted_kennedy'
  # Fixes SSL Error - http://www.techques.com/question/1-5360622/Problems-with-SSL-dependent-gems-OAuth2---ActiveMerchant
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
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

  #def after_sign_in_path_for(resource_or_scope)

  #  case resource_or_scope
  #  when :user, User
   #   store_location = session[:return_to]
    #  clear_stored_location
    #  (store_location.nil?) ? "/artists" : store_location.to_s
  #  else
   #   super
 #   end
# end


#over rides devise default rout after sign in
 private
 #don't know
 def stored_location_for(resource_or_scope)
     nil
 end


  before_filter :instantiate_controller_and_action_names

  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
 #redirects to the sign_in_routing_path in the user model
 def after_sign_in_path_for(resource_or_scope)
      sign_in_routing_path

     # @object = cookies[:object]
     #@song_album_or_event_slug = cookies[:song_album_or_event_slug]
     # assign_to_user (cookies[:object],cookies[:song_album_or_event_slug])
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

  #assigns an object to a user (album, artist, song, ticket, anything you want)
  def assign_to_user (object,object_url_slug)
    if object == "album"
      @user = User.find(current_user.id)
      @album = Album.find_by_album_url_slug(object_url_slug)
      @album.users << @user
      @album.save
      cookies[:object] = {:expires => 1.year.ago}
      cookies[:song_album_or_event_slug] = {:expires => 1.year.ago}
    end
  end
end




