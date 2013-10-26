class Artist < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :users
  has_one :profile_layout

  # Creates Url Slug
  before_create :generate_slug
  before_update :generate_slug


#patch for possible db issue = https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/3486-alternative-to-validates_uniqueness_of-using-db-constraints
 validates_presence_of :name
 validates_uniqueness_of :name, :case_sensitive => false
 validates_format_of :pay_pal, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true

  before_validation :strip_whitespace



  protected
  def generate_slug
    self.url_slug = name.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '')
  end

   def strip_whitespace
      self.name = self.name.strip

	  unless self.pay_pal.nil? || self.pay_pal.blank?
      	self.pay_pal = self.pay_pal.strip
	  end

	  unless self.url_slug.nil? || self.url_slug.blank?
      	self.url_slug = self.url_slug.strip
	  end

	  unless self.city.nil? || self.city.blank?
     	 self.city = self.city.strip
	  end

	  unless self.province.nil? || self.province.blank?
      	self.province = self.province.strip
	  end

	  unless self.country.nil? || self.country.blank?
      	self.country = self.country.strip
	  end
  end



end
