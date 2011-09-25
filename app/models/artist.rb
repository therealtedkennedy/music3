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




end
