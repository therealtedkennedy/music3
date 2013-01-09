class TransactionsController < ApplicationController

  def ipn_save

    @trans = Transaction.new
    @trans.params = request.env['HTTP_REFERER']
    @trans.save

  end

  def index
    @trans = Transaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
   end
  end





end