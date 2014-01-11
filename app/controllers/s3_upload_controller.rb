class S3UploadController < ApplicationController

	#comes from view.  Updates the s3 meta column so that the send_s3_meta_s3 logics works.  That being if song name is different then meta name update the meta name on s3
	def update_s3_meta
		logger.info "in update_s3_meta"
		@song = Song.find(params[:object_id])
		@song.update_column(:s3_meta_tag, params[:s3_meta_name])

		#send data to s3 needs two params song ID and song
		send_s3_meta_s3(params[:object_id],'song')

		respond_to do |f|
			f.json {
				render :json => {
						:success => true}
			}
		end


		logger.info "s3_meta_tag"
		logger.info @song.s3_meta_tag
	end





end
