class Artist < ActiveRecord::Base
  has_many :songs
  before_create :generate_slug

 validates_presence_of :name
 validates_uniqueness_of :name


  protected
  def generate_slug
    self.url_slug = name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '')
  end




end
