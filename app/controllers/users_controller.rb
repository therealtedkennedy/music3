class UsersController < Devise::SessionsController


  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:new, :create, :destroy, :sign_in_routing,:edit,:boo]
  before_filter :authenticate_user!, :except => [:new, :create ]
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create






  #include Devise::Controllers::InternalHelpers
  layout "artist_admin", only: [:show, :edit, :new]



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
      #work around to get background and layout  to load. Eventually users should have there own layouts
      user_initialize

    logger.info "new controller"
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
    logger.info "Sing In Routing Controller"
    if cookies[:object].blank?
      redirect_to(show_user_path(current_user.id))

	#artist is only assigned when its coming from payment routing.
	elsif cookies[:artist].blank?
		#assing_to_user is in the Application controller, assings song and albums to the user
		assign_object_user
		redirect_to(show_user_path(current_user.id))
	else
    #this is the part is currently not being used
		redirect_to(payment_method_path(cookies[:object],cookies[:artist],cookies[:song_album_or_event_id]))
		# deletes the download cookie so that muliple downloads won't happen
		cookies[:artist] = {:expires => 1.year.ago}
    end
  end

   def assign_object_user

	   assign_to_user (cookies[:object]),(cookies[:song_album_or_event_id])
   end

   def boo

  #updates user.  For some strang reason only works when controller is called boo
    @user = User.find(current_user.id)
    authorize! :update, @user



    respond_to do |format|
      if @user.update_attributes(user_params)
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
	logger.info "create controller"
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



  def show
	  logger.info "show controller"


    if user_signed_in?

     @user = User.find(current_user.id)
     authorize! :update, @user

      @load_artist_style = "no"

      #artist 1 is the set up artist.  Houses all the defaults for users who don't have an artist asoiated with them.  Its not the best work around but its effective.
      if Artist.exists?(250)
        @artist = Artist.find(250)
        logger.info("@artist= "+ @artist.url_slug)
      elsif Artist.find_by_url_slug("pearljam").nil?
        @artist = Artist.find_by_url_slug("tedkennedy")
        logger.info("User show..using artist url slug tedkennedy")
        logger.info("@artist= "+ @artist.url_slug)

      else
        @artist = Artist.find_by_url_slug("pearljam")
        logger.info("User show..using artist url slug pearljam")
        logger.info("@artist= "+ @artist.url_slug)

      end


      #defines the type of object it is for the artist_admin layout.  Layout will render for user
      @object_type = "user"

      logger.info "User Found?"
      logger.info @user

      # edit = "true" shows edit screen, false hides it
      #@edit = "true"

      respond_to do |format|
        format.html
        format.json {
          render :json => {
              :success => true,
              :".bodyArea" => render_to_string(
                  :action => 'show.html.erb',
                  :layout => "layouts/user.html.erb",
              ),
              #sets object type to user.  Loads Correct
              :"object_type" => "user"
          }
        }
      end


    else
      redirect_to root_path
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

    if user_signed_in?

     @user = User.find(current_user.id)



      if Artist.exists?(1)
        @artist = Artist.find(1)
      elsif Artist.find_by_url_slug("tedkennedy").nil?
        @artist = Artist.find_by_url_slug("pearljam")
      else
        @artist = Artist.find_by_url_slug("tedkennedy")
      end


      #defines the type of object it is for the artist_admin layout.  Layout will render for user
        @object_type = "user"
        logger.info "In edit"
      logger.info @user
      #searchString  = params[:url_slug]
      #@artist = Artist.find_by_url_slug(searchString)

      #loads form
      @form = render_to_string('users/_form',:layout => false)



      respond_to do |format|
        format.html
        format.json {
          render :json => {
              :success => true,
              :".bodyArea" => render_to_string(
                  :action => 'edit.html.erb',
                  :layout => "layouts/user.html.erb",
              ),
              #show/hides edit screen
              #:"edit" => "true"
              #sets object type to user.  Loads Correct
              :"object_type" => "user"
          }
        }
      end
    end
  end


  def update_password
    logger.info "in update password"
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      logger.info "in user update"
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      sign_in_routing
    else
      logger.info "user update else"
      show
    end
  end



  #don't know what protected does......
  protected

  def stub_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { :methods => methods, :only => [:password] }
  end


  private

  def user_params
    # NOTE: Using `strong_parameters` gem

    params.required(:user).permit(:first_name,:last_name, :email, :pay_pal_email, :password, :password_confirmation,:current_password,:reset_password_token)
  end





end

