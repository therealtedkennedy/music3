class Song< ActiveRecord::Base
 has_and_belongs_to_many:artists

 #creates Url Slug
 #before_create :generate_slug

 before_update :generate_slug


 validates_presence_of :song_name, :on => :update
 validates_uniqueness_of :song_name, :scope => :s_a_id, :case_sensitive => false, :allow_nil => :true


 #validate :url_slug_uniqueness


   protected
 def generate_slug
     self.song_url_slug = song_name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '-')
 end

#private
# def url_slug_uniqueness
  #  artist_song = self.song_name.find(:artist_id])
 #  if self.exists?(:conditions => {:song_name => artist_song})
      # errors.add(:song_name, :name_taken, :song_name=> "#{artist_song}1")
    # end
#  end
 end





