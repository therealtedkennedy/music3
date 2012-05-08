class ProfileLayoutsController < ApplicationController

  def new
  @artist = Artist.find_by_url_slug(params[:url_slug])
  @artist.profile_layout = ProfileLayout.new
  @artist.save

  end
  def edit

    @artist = Artist.find_by_url_slug(params[:url_slug])
    @profile_layout = @artist.profile_layout

    #@profile_layout = ProfileLayout.new
    # @artist.profile_layout = @profile_layout
   # @artist.save


  end

  def update

    @artist = Artist.find_by_url_slug(params[:url_slug])

   # @profile_layout = @artist.profile_layout


    respond_to do |format|
      if @artist.profile_layout.update_attributes(params[:profile_layout])
        format.html { redirect_to(artist_admin_path(params[:url_slug]), :notice => 'Artist was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile_layout.errors, :status => :unprocessable_entity }
      end
    end
  end


end
