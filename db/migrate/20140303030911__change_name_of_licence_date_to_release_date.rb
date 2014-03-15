class ChangeNameOfLicenceDateToReleaseDate < ActiveRecord::Migration

  def self.up
    rename_column :songs, :release_date, :release_date
  end

  def self.down

  end
end

