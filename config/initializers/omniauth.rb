OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter,  ENV['TWITTER_KEY'], "m0nZf7OO7TSDymqdmlJeaIIhsO8hulOGSufFgm40"
end