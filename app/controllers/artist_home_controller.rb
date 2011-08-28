class ArtistHomeController < ApplicationController
  def index
    render :template =>'shared/artist_home'
  end
end
