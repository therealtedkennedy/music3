class UsersController < Devise::SessionsController

  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create
  include Devise::Controllers::InternalHelpers
  layout "artist_layout", only: [:show, :edit]

  def api_login
	  #raise env["omniauth.auth"].to_yaml

      #user = User.find_by_find_by_provider_and_uid(auth['provider'], auth['uid'])
	  user = User.from_omniauth(request.env["omniauth.auth"])
	  logger.info "out of model, checking what user is "
	  logger.info user
		  if user.persisted?
			  flash.notice = "Signed in!"
			  sign_in_and_redirect user
		  else
			  session["devise.user_attributes"] = user.attributes
			  redirect_to new_user_registration_url
		  end

  end

  alias_method :twitter, :api_login



  # GET /resource/sign_in
  def new
    resource = build_resource

    clean_up_passwords(resource)
    respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }

    #work around.  doesn't actually redirect properly after sign in.  should go to sign_in_routing, but doesnt.
	#checks if cookies exisit (from paying for an album) and assigns them to the user
	unless cookies[:object].blank?
		assign_object_user
	end

  end

  #a devise work around to choose the page after sign in or sign up.  Comes from the Application controller
  def sign_in_routing

    if cookies[:object].blank?
      redirect_to(show_user_path(current_user.id))

	#artist is only assigned when its coming from payment routing.
	elsif cookies[:artist].blank?
		#assing_to_user is in the Application controller, assings song and albums to the user
		assign_object_user
		redirect_to(show_user_path(current_user.id))
	else
    #this is the part is currently not being used
		redirect_to(payment_method_path(cookies[:object],cookies[:artist],cookies[:song_album_or_event_slug]))
		# deletes the download cookie so that muliple downloads won't happen
		cookies[:artist] = {:expires => 1.year.ago}
    end
  end

   def assign_object_user
	   assign_to_user (cookies[:object]),(cookies[:song_album_or_event_slug])
   end

   def boo

  #updates user.  For some strang reason only works when controller is called boo
    @user = User.find(current_user.id)

    respond_to do |format|
      if @user.update_attributes(params[:user])
         sign_in @user, :bypass => true
         format.html { redirect_to(show_user_path(@user.id), :notice => 'Artist was successfully updated.') }
         format.xml  { head :ok }
      else
       # format.html { render :action => "edit" }
      #  format.xml  { render :xml => @users.errors, :status => :unprocessable_entity }
      end
    end
  end


  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
     #Assigns object to user after signing in
    # assign_to_user (@object,@song_album_or_event_slug)
      respond_with resource, :location => after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    signed_in = signed_in?(resource_name)
    redirect_path = after_sign_out_path_for(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :signed_out if signed_in

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.any(*navigational_formats) { redirect_to redirect_path }
      format.all do
        method = "to_#{request_format}"
        text = {}.respond_to?(method) ? {}.send(method) : ""
        render :text => text, :status => :ok
      end
    end
  end

  protected

  def stub_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { :methods => methods, :only => [:password] }
  end

 def show
    @user = User.find(params[:id])

	@artist = Artist.find_by_url_slug("grimes")
   respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
   end

 end



 def index
   @user = User.all

     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
   end
 end

   def edit

    @user = User.find(params[:id])

    #searchString  = params[:url_slug]
    #@artist = Artist.find_by_url_slug(searchString)


     respond_to do |format|
           format.html  #show.html.erb
           format.xml  { render :xml => @song }
           format.js
     end
  end




end

