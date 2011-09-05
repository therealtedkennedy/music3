class Song < ActiveRecord::Base
  has_many :artists
end
