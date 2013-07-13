class Album < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :users
  has_many :album_codes, :foreign_key => "code_album_id"
  has_many :orders



before_save :generate_slug
before_update :generate_slug

#validates_presence_of :al_name
validates_presence_of :al_name, :on => :update
validates_uniqueness_of :al_name, :scope => :al_a_id, :case_sensitive => false, :allow_nil => :true
before_validation :strip_whitespace


  def generate_slug
    self.album_url_slug = al_name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '')
  end

	def strip_whitespace
		self.al_name = self.al_name.strip
		self.pri_artist = self.pri_artist.strip
		self.contrib_artist = self.contrib_artist.strip
		self.producer = self.producer.strip
		self.liner_notes = self.liner_notes.strip
		self.description = self.description.strip
	end




end
