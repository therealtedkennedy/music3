class ProfileLayoutsController < ApplicationController

	layout "profile_edit_layout", only: [:edit]


	def new
		@artist = Artist.find_by_url_slug(params[:url_slug])
		@artist.profile_layout = ProfileLayout.new
		@artist.save
	end

	def edit

		@artist = Artist.find_by_url_slug(params[:url_slug])
		@profile_layout = @artist.profile_layout


		render 'artists/show'
		#@profile_layout = ProfileLayout.new
		# @artist.profile_layout = @profile_layout
		# @artist.save


	end

	def update

		@artist = Artist.find_by_url_slug(params[:url_slug])

		# @profile_layout = @artist.profile_layout


		respond_to do |format|
			if @artist.profile_layout.update_attributes(params[:profile_layout])
					format.json {
						render :json => {
								:success => true}
						}
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @profile_layout.errors, :status => :unprocessable_entity }
			end
		end
	end


end
