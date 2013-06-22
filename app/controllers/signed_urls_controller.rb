class SignedUrlsController < ApplicationController

	def index
		logger.info "Policy Doc"

		#finds bucket based on the object type. Returns bucket name
		find_bucket(params[:object])
		logger.info "bucket is "+@bucket


		logger.info render json: {
				policy: s3_upload_policy_document(@bucket),
				signature: s3_upload_signature(@bucket),
				key: "#{params[:doc][:title]}",
				success_action_redirect: "/"
		}
	end

	private

	# generate the policy document that amazon is expecting.  The policy document defines what fields are required in the post, and values.
	def s3_upload_policy_document(s3_bucket)


		Base64.encode64(
				       {
						expiration: 30.minutes.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
						conditions: [
								{ bucket: s3_bucket },
								{ acl: 'public-read' },
								["starts-with", "$key", ""],

								["starts-with", "$Content-Disposition", ""],
								#["starts-with", "$Content-Type", ""],
								["content-length-range", 0, 524288000],
								["starts-with", "$x-amz-meta-my-file-name", ""],
								{ success_action_status: '201' }
						]
 				}.to_json
		).gsub(/\n|\r/, '')

	end




	# sign our request by Base64 encoding the policy document.
	def s3_upload_signature(s3_bucket)
		Base64.encode64(
				OpenSSL::HMAC.digest(
						OpenSSL::Digest::Digest.new('sha1'),
						S3_KEY,
						s3_upload_policy_document(s3_bucket)
				)
		).gsub(/\n/, '')
	end







end