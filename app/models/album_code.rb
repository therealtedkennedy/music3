class AlbumCode < ActiveRecord::Base
 belongs_to :album

 def self.to_csv_3

	 CSV.generate  do |csv|
		 csv << ["Album Codes"]
		 all.each do |album_codes|
            csv << album_codes.attributes.values_at("album_code")
		 end
	 end
 end
end
