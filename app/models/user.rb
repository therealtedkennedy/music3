class User < ActiveRecord::Base
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :albums
  has_many :songs


  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :pay_pal_email


  #def self.from_omniauth(auth)
  #
	# user = self.find_by_twitter_uid(auth['uid'])
  #
	#  logger.info "Is self Defined"
	#  logger.info user
  #
	#  if user.nil?
  #
	#	    self.create!(:email => auth.email, :provider => auth.provider, :twitter_uid => auth.uid, :twitter_nickname => auth.info.nickname)
  #  		#@user = self.new
	#		#logger.info "after self.new"
	#		#logger.info  self
	#		#@user.provider = auth.provider
	#	    #@user.twitter_uid = auth.uid
	#	    #@self.twitter_nickname = auth.info.nickname
  #
  #
	#		logger.info "in self.nil "
  #
	#  end
  #
  #end

  def self.new_with_session(params, session)
	  if session["devise.user_attributes"]
		  new(session["devise.user_attributes"], without_protection: true) do |user|
			  user.attributes = params
			  user.valid?
		  end
	  else
		  super
	  end
  end

  def password_required?
	  super && provider.blank?
  end

  def update_with_password(params, *options)
	  if encrypted_password.blank?
		  update_attributes(params, *options)
	  else
		  super
	  end
  end



end
