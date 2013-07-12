#Explanation here - http://net.tutsplus.com/tutorials/create-a-simple-music-streaming-app-with-ruby-on-rails/
class SongsController < ApplicationController
	#lists songs called from S3 Server


	before_filter :authenticate_user!, :except => [:show, :index, :song_play_counter,:artist_show_song,:song_play_counter]


	#changes from default layout to custom layout
	layout "artist_admin", only: [:show,:index]

  #shows all artists songs (built by ronnie)
	def index
		#not #nessisary
		#@s3_songs = AWS::S3::Bucket.find(BUCKET).objects

		#@songs = Song.all
		@artist = Artist.find_by_url_slug(params[:url_slug])
		@songs = @artist.songs

		respond_to do |format|
			format.html # index.html.erb
			format.xml { render :xml => @song }
			format.json {
				render :json => {
						:success => true,
						:"#content" => render_to_string(
								:action => 'index.html.erb',
								:layout => false
						)

				}
			}
		end
	end

	#not used should delete in production.  Deletes S3 songs from Index
	#def delete (song)
	# if (params[:song])
	#  AWS::S3::S3Object.find(params[:song], BUCKET).delete
	# redirect_to songs_path
	#  else
	#  render :text => "No song was found to delete!"
	#  end
	# end


	def show


		if params[:song_url_slug]
			#@artist = Artist.find(params[:id])
			#@artist = Artist.find_by_url_slug(params[:url_slug])
			@artist = Artist.find_by_url_slug(params[:url_slug])
			#in the appication controller.  Used by profile edit.
			find_song(@artist, params[:song_url_slug])

			song_social(@artist,@song)

			# @song.artists.uniq.each do |artist|
			#   @artist_slug = artist.url_slug
			# end
			respond_to do |format|
				format.html # show.html.erb
				format.xml { render :xml => @song }
				format.json {
					render :json => {
							:success => true,
							:"#content" => render_to_string(
									:action => 'show.html.erb',
									:layout => false
							),
					    	:"show" => "true",


					}
				}
			end


		else

			@song = Song.find(params[:id])


			respond_to do |format|
				format.html #show.html.erb
				format.xml { render :xml => @song }
			end
		end
	end


	#renders edit page.  Required for form upload @object_type (song, image, album, whatever) and @id a unique id for  s3 and bucket defines which bucket it should be uploaded too
	def edit

		@song = Song.find(params[:id])
		#makes sure that when url is called (non ajax) the page loads the correct variable.  See admin layout
		@edit = "true"
		#finds the assoicated artist
		@artist = Artist.find(@song.s_a_id)
		authorize! :update, @artist
		#searchString  = params[:url_slug]
		#@artist = Artist.find_by_url_slug(searchString)
		@id = @song.id
        @object_type = "song"
		@bucket = BUCKET
		@object_id = @song.s3_id


		#renders from because at the time of this writing form partials won't load in ajax
		@form = render_to_string('songs/_form',:layout => false)
		@s3_upload = render_to_string('shared/_s3_upload_form', :layout => false)

		#updates s3 meta data. takes artist slug, object id (for song, album ect.  if one doesn't exist =1), and object type (song,album,image ect)
		@meta_update_url = update_s3_meta_url(@artist.url_slug,@song.id,@object_type)

		#preps image form
		image_upload_prep(@artist,@song)

		respond_to do |format|
			format.html {render :layout => 'artist_admin'}
			format.xml { render :xml => @song }
			format.js
			format.json {
				render :json => {
						:success => true,
						:".editScreen" => render_to_string(
								:action => 'edit.html.erb',
								:layout => false,

						),
						 :"id" => @song.s3_id,
						:"edit" => "true",
				}
			}
		end
	end

	def save_amazon_file(amazon_id, mp3file, name, artist)
		authorize! :update, artist
		if	s3_save(amazon_id,mp3file,name,BUCKET,":mpeg",".mp3")
			return true;
		else
			return false;
		end
	end


# Updates Artist Info ...not sure if this is used anymore
	def used_to_be_upadate
		@song = Song.find(params[:id])


		respond_to do |format|
			if @song.update_attributes(params[:song])
				format.html { redirect_to(song_path(@song.id), :notice => 'Artist was successfully updated.') }
				format.xml { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml { render :xml => @artist.errors, :status => :unprocessable_entity }
			end
		end
	end


	#renders edit page.  Required for form upload @object_type (song, image, album, whatever) and @id a unique id for  s3
	def new


		@artist = Artist.find_by_url_slug(params[:url_slug])
		@song = Song.new
		@artist_id = @artist.id
		@song.s_a_id = @artist.id
		@song.s3_id= @song.id.to_s + ".mp3"
		@song.save

		#@song.s3_id= @song.id.to_s + ".mp3"
		#@song.save


		@s3_key = S3_KEY
		@bucket = BUCKET
		@object_type = "song"
		@object_id = @song.s3_id




		@form = render_to_string('songs/_form_upload_song',:layout => false)
		@s3_upload = render_to_string('shared/_s3_upload_form', :layout => false)

#u      Updates s3 meta data. takes artist slug, object id (for song, album ect.  if one doesn't exist =1), and object type (song,album,image ect)
		@meta_update_url = update_s3_meta_url(@artist.url_slug,@song.id,@object_type)

		@edit = "true"  #makes sure that when url is called (non ajax) the page loads the correct variable.  See admin layout

        logger.info "form"
		logger.info @form

		logger.info "s3_upload form"
		logger.info @s3_upload

        #preps form for image upload
		image_upload_prep(@artist,@song)

		respond_to do |format|
			format.html {render :locals => {:partial => "form_upload_song"},:layout => 'artist_admin'}
			format.xml { render :xml => @song }
			format.js
			format.json {
				render :json => {
						:success => true,
						:".editScreen" => render_to_string(
								:action => 'new.html.erb',
								:layout => false,

						),
						:"id" => @song.s3_id,
						:"edit" => "true",

				}
			}
		end
	end


	def update
		@artist = Artist.find(params[:artist_id])
		authorize! :update, @artist
		@song = Song.find(params[:form_song_id])
		@song.artists << @artist
		@s3_test = params[:s3_name]


		#song s3 key, download link and torrent link
		@song.s3_id= @song.id.to_s + ".mp3"
		#@amazon_id = @song.id.to_s + ".mp3"


		#if params[:song].has_key?("s3_name")
		#	#save_amazon_file(@song.s3_id, params[:song][:s3_name], params[:song][:song_name], @artist)
		#
		#
		#
		#end



		#if @song.s3_id.blank?
		#@song.s3_id= params[:id].to_s + ".mp3"
		# @song.download_link = download_url_for(@song.s3_id)
		#@song.torrent_link= link_to(torrent_url_for(@song.s3_name))
		#end

		params[:song].delete :s3_name



		@song.update_attributes(params[:song])

		logger.info "song nae is="
		logger.info @song.song_name
		logger.info "meta name is"


		#not going to work there buddy.

		if @song.s3_meta_tag.nil?

		else
			send_s3_meta_s3(@song.id,'song')
		end


		respond_to do |format|
			if @song.update_column(:s3_id, @song.s3_id)
				format.html { redirect_to (artist_show_song_path(@artist.url_slug, @song.song_url_slug)), :notice => 'Song was successfully created.' }
				format.xml { head :ok }
				format.json {
					render :json => {
							:success => true,
							:"url" => artist_show_song_url(@artist.url_slug, @song.song_url_slug)
					}
				}
			else
				format.html { render :action => "edit" }
				format.xml { render :xml => @artist.errors, :status => :unprocessable_entity }
			end
		end
	end

	#uploads songs from S3 Server. Not sure if this is used any more.

	#def upload
	#	#@id = params[:song_id]
	#	#@s3_key = @id+".mp3"
	#
	#	begin
	#		AWS::S3::S3Object.store(sanitize_filename(params[:mp3file].original_filename), params[:mp3file].read, BUCKET, :access => :public_read)
	#
	#	end
	#
	#rescue
	#	render :text => "Couldn't complete the upload"
	#
	#
	#	respond_to do |format|
	#		format.js { render }
	#
	#	end
	#end


	# def download


	#  @song = Song.find_by_song_url_slug(params[:song_url_slug])
	#  @artist =  Artist


	#  @song_file = AWS::S3::S3Object.value(@song.s3_id, BUCKET)
	#  send_file(@song_file,
	#        :filename  =>  @song.song_name+".mp3")

	#    respond_to do |format|
	#       format.html  redirect_to(song_path(@song.id), :notice => 'Song was downloaded.')
	#       format.xml
	#      format.js
	#   end
	#  end


	#deletes song info from Model
	def destroy

        logger.info "in destroy"

		@song = Song.find(params[:song_id])
		@artist = Artist.find(@song.s_a_id)
		authorize! :update, @artist


		@song.destroy


		(@song.s3_id)
		s3_delete(BUCKET, @song.s3_id)

		redirect_to(artist_admin_path(@artist.url_slug))

	end


	# Shows a specific artists song
	def artist_show_song

		#@artist = Artist.find(params[:id])
		searchString = params[:url_slug]
		@artist = Artist.find_by_url_slug(searchString)
		@song = @artist.song.find.by_url_slug(params[:song_name])

		respond_to do |format|
			format.html # show.html.erb
			format.xml { render :xml => @artist }
		end
	end

	def song_play_counter
		@song = Song.find_by_id(params[:song_id])
		@song.song_plays = @song.song_plays || 0
		@song.song_plays = @song.song_plays + 1
		#@song.update_column(:song_play, @song.song_plays)
		@song.save

		respond_to do |format|
			format.json {
				render :json => @song.to_json
			}
		end
	end


	#sets up image upload forms for s3
	def image_upload_prep(artist,song)

		logger.info("in image prep")
		logger.info artist
		logger.info song

		song_image_name = "Three_Repeater-"+artist.url_slug+"-"+song.id.to_s+"-"
		@bucket = IMAGE_BUCKET

		@image_save_location = song_save_image_url(artist.url_slug,song.id.to_s)

		#song_image_uplosd
		@song_image_upload = render_to_string('shared/_s3_upload_form_image', :locals => {:image_name => song_image_name, :image_type => "song_image", :image_save_url => @image_save_location}, :layout => false)

	end

	#saves image location from s3.
	def song_save_image

		@song = Song.find(params[:song_id])
		@artist = Artist.find_by_url_slug(params[:url_slug])

		@song.image = "https://ted_kennedy_image.s3.amazonaws.com/Three_Repeater-"+@artist.url_slug+"-"+@song.id.to_s+"-"+params[:file_name]

		@song.update_column(:image,@song.image)

		logger.info("song image= "+@song.image.to_s)

		respond_to do |f|

			f.json {
				render :json => {
						:success => true}
			}

		end

	end





	private
	# Internet Explorer work around see - http://net.tutsplus.com/tutorials/create-a-simple-music-streaming-app-with-ruby-on-rails/
	def sanitize_filename(file_name)
		just_filename = File.basename(file_name)
		just_filename.sub(/[^\w\.\-]/, '_')
	end



end
