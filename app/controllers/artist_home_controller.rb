class ArtistHomeController < ApplicationController

	layout 'homepage'

  def index

	respond_to do |format|
		format.html
	end
  end
end
