class Song< ActiveRecord::Base
 has_and_belongs_to_many :artists
 has_and_belongs_to_many :albums
 has_many :orders

 #creates Url Slug
 #before_create :generate_slug

 before_update :generate_slug

 validates :song_name, :presence => {:message => 'Name cannot be blank'}
 validates :song_name, uniqueness: {scope: :s_a_id, case_sensitive: false,  message: "Name has already been taken please choose another." }, allow_nil: true

 before_validation :strip_whitespace



 def get_download_link
	 self.download_url_for(self.s3_id)
 end
 #validate :url_slug_uniqueness


   protected
 def generate_slug
     self.song_url_slug = song_name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '-')
 end


 def strip_whitespace
	 unless self.song_name.nil?
		 self.song_name = self.song_name.strip
		 self.song_artist = self.song_artist.strip
		 # self.song_contribute_artist = self.song_contribute_artist.strip
		 self.song_written = self.song_written.strip
		 self.lyrics = self.lyrics.strip
	end
 end



#private
# def url_slug_uniqueness
  #  artist_song = self.song_name.find(:artist_id])
 #  if self.exists?(:conditions => {:song_name => artist_song})
      # errors.add(:song_name, :name_taken, :song_name=> "#{artist_song}1")
    # end
#  end
 end





