class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  before_filter :authenticate_user!

  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  def payment_method
       #user selects payment type.  All relevant var's passed through params.  Amount is use for PWYC, all other times its just a place holder
    @album = Album.find_by_album_url_slug(params[:album_url_slug])
    @user = current_user
    logger.info "User ID"
    logger.info @user.id


    @user.albums.uniq.each do |album|
      logger.info "album Url Slug"
      logger.info album.album_url_slug
      logger.info "params album"
      logger.info params[:song_album_or_event_slug]
      if album.album_url_slug == params[:song_album_or_event_slug]
        redirect_to show_user_path(@user.id), notice => "WHOA! YOU HAVE ALREADY DOWNLOADED THIS(SEE BELOW"
      else


      end

    end


  end

  def express

  payment_prep(params[:object], params[:url_slug], params[:song_album_or_event_slug], params[:amount])
  #your at minute 8:28...have to figure out how this works and what this does
  response = EXPRESS_GATEWAY.setup_purchase(@amount*100,
    :ip => request.remote_ip,
    :return_url => login_prompt_url,

    #:return_url =>  album_download_url(@artist.url_slug, @album.id),
    :cancel_return_url => @cnx_url
  )

  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def chained_payment
  #uses https://github.com/jpablobr/active_paypal_adaptive_payment
  # SSL error - http://stackoverflow.com/questions/4528101/ssl-connect-returned-1-errno-0-state-sslv3-read-server-certificate-b-certificat

  payment_prep(params[:object], params[:url_slug], params[:song_album_or_event_slug], params[:amount])

  recipients = [{:email => 'therea_1326852847_biz@gmail.com',
                 :amount => @amount,
                 :primary => true},
                {:email => @artist.pay_pal,
                 :amount => "%.2f" % (@amount*0.85),
                 :primary => false}
                 ]
  response = CHAINED_GATEWAY.setup_purchase(
    :return_url => login_prompt_url,
    :cancel_url => login_prompt_url,
    #:ipn_notification_url => ipn_save_url,
    :receiver_list => recipients
  )

  # for redirecting the customer to the actual paypal site to finish the payment.
  @paykey = (CHAINED_GATEWAY.redirect_url_for(response["payKey"])).split('&')
  @paykey = @paykey.fetch(1)



  cookies[:paykey] = {
      :value => [@paykey],
      :expires => 30.minutes.from_now

       }
  redirect_to (CHAINED_GATEWAY.redirect_url_for(response["payKey"]))
  end

  #creates download link, payment amount, and object vars, and sets a cookie
 def payment_prep(object,artist_url_slug,song_album_or_event_slug,amount)
   @object = object

   #finds Artist
   @artist = Artist.find_by_url_slug(artist_url_slug)
   #prep for album

   if @object == "album"
     @album = Album.find_by_album_url_slug(song_album_or_event_slug)
     @download_url = album_download_url(artist_url_slug,song_album_or_event_slug)
     @cnx_url = artist_show_album_url(artist_url_slug,song_album_or_event_slug)

     if @album.pay_type = "pay"
         @amount = @album.al_amount

     else
        @amount = 100
        # @amount = amount.to_i
     end

   else

   #don't know why this didn't work. Just did the calculation in the chained payment model
   #@amount_to_artist = "%.2f" % (@amount*0.85)

  end

  #Passes Cookie Download
  cookies[:next_step] = {
      :value => [@download_url],
      :expires => 30.minutes.from_now

       }

   #passes values to assign object to users who are not signed in.
   if user_signed_in? != true
     cookies[:object] = {
        :value => [object],
        :expires => 30.minutes.from_now

         }

     cookies[:song_album_or_event_slug] = {
        :value => [song_album_or_event_slug],
        :expires => 30.minutes.from_now

       }
    end
  end
     # GET /orders/new
  # GET /orders/new.xml
  def new
    @album =  Album.find_by_album_url_slug(params[:album_url_slug])
    @order = Order.new(:express_token => params[:token], :album_id => @album.id)
    @album_id = @album.id
    @artist_url_slug = params[:url_slug]


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = params[:order]
    @album = Album.find(params[:order][:album_id])
    @order = @album.orders.build(@order)
    #@order.ip_address = request.remote_ip

    if @order.save
    @order.purchase
     # if @order.purchase
        #render :action => "download_album", :url_slug => @album.al_a_id, :id => @album.id
        #redirect_to(album_download_path(@album.al_a_id, @album.id), :notice => 'Artist was successfully updated.')
      # render :action => "success"
    #  else
     #  render :action => "failure"
    #  end
   # else
    #  render :action => 'new'
   end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to(@order, :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end



  # DELETE /orders/1
  # DELETE /orders/1.xml

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

  def login_prompt
    logger.info "Login Prompt"

    if can? :update, @artist

       redirect_to(show_user_path(current_user.id, :token => params[:token], :PayerID =>params[:PayerID]))

    end


  end
end
