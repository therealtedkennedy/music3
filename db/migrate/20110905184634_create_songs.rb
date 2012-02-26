class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :song_name
      t.string :song_artist
      t.string :song_contribute_artist
      t.string :song_written
      t.string :song_licence_type
      t.date :song_licence_date
      t.integer :song_plays
      t.text :lyrics
      #t.string :song_url_slug

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
