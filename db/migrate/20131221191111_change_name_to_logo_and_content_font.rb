class ChangeNameToLogoAndContentFont < ActiveRecord::Migration
  def self.up
    rename_column :profile_layouts, :h1_font, :logo_font
    rename_column :profile_layouts, :h2_font, :content_font
  end

  def self.down

  end
end
