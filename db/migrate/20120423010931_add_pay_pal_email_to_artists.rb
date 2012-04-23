class AddPayPalEmailToArtists < ActiveRecord::Migration
    def self.up
    add_column :artists, :pay_pal, :string

   end

  def self.down
    remove_column :artists, :pay_pal
  end
end
