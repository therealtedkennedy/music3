class ChangeNameOfLicenceDateToReleaseDate < ActiveRecord::Migration

  def self.up
    rename_column :songs, :song_licence_date, :release_date
  end

  def self.down

  end
end

