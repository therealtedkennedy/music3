class Artist < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :users

  # Creates Url Slug
  before_create :generate_slug
  before_update :generate_slug


#patch for possible db issue = https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/3486-alternative-to-validates_uniqueness_of-using-db-constraints
 validates_presence_of :name
 validates_uniqueness_of :name, :case_sensitive => false


  protected
  def generate_slug
    self.url_slug = name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '')
  end




end
