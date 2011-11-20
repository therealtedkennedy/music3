class Artist < ActiveRecord::Base
  has_and_belongs_to_many:songs

  # Creates Url Slug
  before_create :generate_slug
  before_update :generate_slug

 validates_presence_of :name
 validates_uniqueness_of :name


  protected
  def generate_slug
    self.url_slug = name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '')
  end

  def self.has_song_slug?(artist_id, song_url_slug)
   artist_id = self.find(artist_id)
   allSlugs = self.songs.map{|t| t.song_url_slug}
   return allSlugs.include?(song_url_slug)
  end

end
