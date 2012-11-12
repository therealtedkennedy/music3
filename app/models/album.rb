class Album < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :users
  mount_uploader :art, BkImageUploader
  has_many :album_codes, :foreign_key => "code_album_id"
  has_many :orders




#before_create :generate_slug
before_update :generate_slug

#validates_presence_of :al_name
validates_uniqueness_of :al_name, :scope => :al_a_id, :case_sensitive => false, :allow_nil => :true



  def generate_slug
    self.album_url_slug = al_name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '')
  end




end
