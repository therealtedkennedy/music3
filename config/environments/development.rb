Music3::Application.configure do


  # Settings specified here will take precedence over those in config/application.rb
  Rails.logger = Logger.new(STDOUT)
  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.


  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  config.action_controller.action_on_unpermitted_parameters = :raise

# Log the query plan for queries taking more than this (works
# with SQLite, MySQL, and PostgreSQL)
	config.active_record.auto_explain_threshold_in_seconds = 0.5

	config.log_tags = [:uuid, :remote_ip]

  #mailer configuration
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true


	ActionMailer::Base.delivery_method = :smtp
  	ActionMailer::Base.smtp_settings = {
			:address   => "smtp.mandrillapp.com",
			:port      => 587, # ports 587 and 2525 are also supported with STARTTLS
			:enable_starttls_auto => true, # detects and uses STARTTLS
			:user_name => "app6560736@heroku.com",
			:password  => "rF_3BOJq9DcpPYrSVKAu-Q", # SMTP password is any valid API key
			:authentication => 'plain', # Mandrill supports 'plain' or 'login'
			:domain => 'heroku.com', # your domain to identify your server when connecting
	}


  config.action_mailer.default_url_options = { :host => 'www.threerepeater.com' }


  ENV["TWITTER_KEY"] = "PkEuRrYyt4wWlQIX9BCXA"
  ENV["TWITTER_SECRET"] = "m0nZf7OO7TSDymqdmlJeaIIhsO8hulOGSufFgm40"

  config.action_mailer.default_url_options = { :host => 'localhost:3000'}

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  paypal_options = {
    :login => "edward_api1.threerepeater.com",
    :password => "1326852885",
    :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31ASJSfLthOmKchEACDPMUl0iUA9Kt",

  }
  ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  ::CHAINED_GATEWAY =  ActiveMerchant::Billing::PaypalAdaptivePayment.new(
      :login => "therea_1326852847_biz_api1.gmail.com",
      :password => "1326852885",
      :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31ASJSfLthOmKchEACDPMUl0iUA9Kt",
      :appid => "APP-80W284485P519543T",

  )


  end

end


