class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
   # before_filter :
	#before_filter :authenticate_user!, :except => [:payment_method,:chained_payment]

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

  if params[:object] == "album"
    #user selects payment type.  All relevant var's passed through params.  Amount is use for PWYC, all other times its just a place holder
    @album = Album.find(params[:song_album_or_event_id])
    logger.info "Album somthing"+@ablum.to_s


    if params[:amount].nil?
      @amount = @album.al_amount

    else
      @amount = params[:amount]
    end

  elsif params[:object] == "song"

    @amount = params[:amount]

    logger.info "in song. amount= "+ @amount

  end


	#checks if user has downloaded already
    downloaded_already(params[:song_album_or_event_id])

    logger.info "Object Param= "+params[:object].to_s
    logger.info "Artist Slug Param= "+params[:url_slug].to_s
    logger.info "Song_album_or_event_id= "+params[:song_album_or_event_id].to_s

    if params[:amount] == "0"

      payment_prep(params[:url_slug],params[:object],params[:song_album_or_event_id],"0")
      redirect_to social_promo_url(params[:url_slug],params[:object],params[:song_album_or_event_id])

    else

      redirect_to chained_payment_path(params[:url_slug],params[:object],params[:song_album_or_event_id],:amount => @amount)

    end





  end

  def download_without_paypal(url_slug,object,song_album_or_event_id)


      return

  end


  def downloaded_already (song_album_or_event_slug)
	  #checks if user is logged in.

  unless current_user.nil?

		  @user = current_user
		  logger.info "User ID"
		  logger.info @user.id

		  #checks to see if user allready downloaded album
		  @user.albums.uniq.each do |album|
			  logger.info "album Url Slug"
			  logger.info album.album_url_slug
			  logger.info "params album"
			  logger.info params[song_album_or_event_slug]

			  if album.album_url_slug == params[song_album_or_event_slug]

				  flash[:notice] = "WHOA! YOU HAVE ALREADY DOWNLOADED THIS(SEE BELOW)"
				  redirect_to show_user_path(@user.id)
			  else

			  end

		  end
	  end
  end


  #sets up cookies for payment process
  def free_download
	#checks if user has downloaded already
	downloaded_already(params[:song_album_or_event_id])

	payment_prep(params[:object], params[:url_slug], params[:song_album_or_event_id], params[:amount])
	redirect_to (login_prompt_url)
  end

    #pwyc payment process
	def pwyc

		#space param is a work around ?redir="true" is being added to the last paramter in this path..i have no idea why
		redirect_to payment_method_path(params[:object], params[:url_slug], params[:song_album_or_event_id],:amount => params[:amount],:space => "blah")
	end


  def chained_payment
  #uses https://github.com/jpablobr/active_paypal_adaptive_payment
  # SSL error - http://stackoverflow.com/questions/4528101/ssl-connect-returned-1-errno-0-state-sslv3-read-server-certificate-b-certificat
  logger.info "artist url slug "+ params[:url_slug].to_s

  #@artist = Artist.find_by_url_slug(params[:url_slug])


  logger.info "amount in chained payment before payment prep= "+@amount.to_s
  payment_prep(params[:url_slug],params[:object], params[:song_album_or_event_id], params[:amount])
  logger.info "amount in chained payment after payment prep= "+@amount.to_s
  logger.info "Artist?= "+@artist.name


  #sets test or main user for paypal chained payments

  if Rails.env.development? || Rails.env.dev_kennedy?

    @pay_pal_user = "therea_1326852847_biz@gmail.com"

  else

    @pay_pal_user = "edward@threerepeater.com"

  end


  recipients = [{:email =>  @artist.pay_pal,
                 :amount => @amount,
                 :primary => true},
                {:email => @pay_pal_user,
                 :amount => "%.2f" % (@amount*0.20),
                 :primary => false}
                 ]
  response = CHAINED_GATEWAY.setup_purchase(


    :return_url => social_promo_url(@artist.url_slug,params[:object],params[:song_album_or_event_id]),
    :cancel_url => login_prompt_url,
    #:ipn_notification_url => ipn_save_url,
    :receiver_list => recipients
  )

  logger.info "paypal response= "+response.to_s

  logger.info "return_url "+ social_promo_url(@artist.url_slug,params[:object],params[:song_album_or_event_id])

  # for redirecting the customer to the actual paypal site to finish the payment.
  @paykey = (CHAINED_GATEWAY.redirect_url_for(response["payKey"])).split('&')
  logger.info "paykey= "+@paykey.to_s
  @paykey = @paykey.fetch(1)



  cookies[:paykey] = {
      :value => [@paykey],
      :expires => 30.minutes.from_now

       }
  redirect_to (CHAINED_GATEWAY.redirect_url_for(response["payKey"]))
  puts CHAINED_GATEWAY.debug
  end

  #creates download link, payment amount, and object vars, and sets a cookie
 def payment_prep(artist_url_slug,object,song_album_or_event_id,amount)
	   @object = object

     logger.info "params amount"
	   logger.info amount

	   #finds Artist
	   @artist = Artist.find_by_url_slug(artist_url_slug)
	   #prep for album

	   if @object == "album"
       @album = Album.find(song_album_or_event_id)
       @download_url = album_download_url(artist_url_slug,@album.album_url_slug)
       @cnx_url = artist_show_album_url(artist_url_slug,@album.album_url_slug)


       if @album.pay_type == "pay"
         @amount = @album.al_amount

       elsif @album.pay_type == "pwyc"
         @amount = amount

         logger.info "in pwyc in payment prep"
         logger.info "params amount"
         logger.info amount
         logger.info "@amount"
         @amount = @amount.to_i
         logger.info @amount

       else

         @amount = amount

         logger.info "in payment prep"
         logger.info "params amount"
         logger.info amount
         logger.info "@amount"
         @amount = @amount.to_i
         logger.info @amount

       end
        logger.info @amount

     elsif @object = "song"

         @song = Song.find(song_album_or_event_id)

         @download_url = "https://s3.amazonaws.com/"+BUCKET+"/"+@song.id.to_s+".mp3"


         @cnx_url = artist_show_song_url(artist_url_slug,@song.song_url_slug)

         @amount = amount
         @amount = @amount.to_i


      else

    #how much the artist makes is calculated in the chained payment model


	  end

	  #Passes Cookie Download
	  cookies[:next_step] = {
		  :value => [@download_url],
		  :expires => 30.minutes.from_now

		   }

     cookies[:amount] = {
         :value => [amount],
         :expires => 30.minutes.from_now

     }

	   #passes values to assign object to users who are not signed in.
	   if user_signed_in? != true
		 cookies[:object] = {
			:value => [object],
			:expires => 30.minutes.from_now

			 }

		 cookies[:song_album_or_event_id] = {
			:value => [song_album_or_event_id],
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

    if current_user.nil?

	else

       redirect_to(show_user_path(current_user.id, :token => params[:token], :PayerID =>params[:PayerID], :fully =>"completely"))

    end


  end
end
