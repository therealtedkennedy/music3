Music3::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict


  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true


  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  ENV["TWITTER_KEY"] = "PkEuRrYyt4wWlQIX9BCXA"
  ENV["TWITTER_SECRET"] = "m0nZf7OO7TSDymqdmlJeaIIhsO8hulOGSufFgm40"

  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
        :login => "therea_1326852847_biz_api1.gmail.com",
        :password => "1326852885",
        :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31ASJSfLthOmKchEACDPMUl0iUA9Kt",

    }
    ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
    ::CHAINED_GATEWAY =  ActiveMerchant::Billing::PaypalAdaptivePayment.new(
        :login => "therea_1326852847_biz_api1.gmail.com",
        :password => "1326852885",
        :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31ASJSfLthOmKchEACDPMUl0iUA9Kt",
        :appid => "APP-80W284485P519543T"
    )


	config.default_url_options = { :host => 'threerepeater.com'}
	ActionMailer::Base.delivery_method = :smtp
	# Don't care if the mailer can't send
	config.action_mailer.raise_delivery_errors = true

	#config.action_mailer.delivery_method = :smtp
	#config.action_mailer.sendmail_settings = {
	#		address: "smtp.mandrillapp.com",
	#		port: 587,
	#		domain: "heroku.com",
	#		authentication: "plain",
	#		user_name: "app6560736@heroku.com",
	#		password:"CMGqTla1DR71Z-DawNGRQ",
	#}
  #end
	ActionMailer::Base.delivery_method = :smtp
  #config.action_mailer.delivery_method = :smtp
	ActionMailer::Base.smtp_settings = {
		  :address   => "smtp.mandrillapp.com",
		  :port      => 587, # ports 587 and 2525 are also supported with STARTTLS
		  :enable_starttls_auto => true, # detects and uses STARTTLS
		  :user_name => "app6560736@heroku.com",
		  :password  => "rF_3BOJq9DcpPYrSVKAu-Q", # SMTP password is any valid API key
		  :authentication => 'plain', # Mandrill supports 'plain' or 'login'
		  :domain => 'heroku.com', # your domain to identify your server when connecting
  }
  end

end
