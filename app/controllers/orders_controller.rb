class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
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




  def express

    @album = Album.find(params[:album_id])



  #your at minute 8:28...have to figure out how this works and what this does
  response = EXPRESS_GATEWAY.setup_purchase(@album.al_amount*100,
    :ip                => request.remote_ip,
    :return_url        => new_order_w_album_id_url(@album.id),
    :cancel_return_url => artist_show_album_url(params[:url_slug],@album.album_url_slug)
  )

  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end

     # GET /orders/new
  # GET /orders/new.xml
  def new

    @order = Order.new(:express_token => params[:token], :album_id => params[:album_id])
    @album_id = params[:album_id]

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
    @order.ip_address = request.remote_ip

    if @order.save
      if @order.purchase
        render :action => "success"
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
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
end
