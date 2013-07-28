class Album < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :users
  has_many :album_codes, :foreign_key => "code_album_id"
  has_many :orders

before_update :generate_slug
before_save :generate_slug
before_validation :strip_whitespace

validates :al_name, :presence => {:message => 'Name cannot be blank'}

#validates for new.  No al_a_id (album artist id for primary artist) has been assoated yet
#validates :al_name, uniqueness: {scope: , case_sensitive: false,  message: "Name has already been taken please choose another." }, allow_nil: true

#validates for update.  For some reason above validiation doens't work.  So using al_a_id
validates :al_name, uniqueness: {scope: :al_a_id, case_sensitive: false,  message: "Name has already been taken please choose another." }

  def generate_slug
    self.album_url_slug = al_name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '')
  end

	def strip_whitespace
		unless self.al_name.nil?
			self.al_name = self.al_name.strip
			self.pri_artist = self.pri_artist.strip
			self.contrib_artist = self.contrib_artist.strip
			self.producer = self.producer.strip
			self.liner_notes = self.liner_notes.strip
			self.description = self.description.strip
		end
	end

	#def set_album_id
	#	logger.info("in set album id")
	#	logger.info(self.al_a_id)
	#	logger.info(self.album_artist_id)
	#
	#	if self.al_a_id.blank? || self.al_a_id.nil?
	#		logger.inf
	#		self.al_a_id = self.album_artist_id
	#	end
	#end



end
