class ProfileEditAddBackgroundImage < ActiveRecord::Migration
  def up
    add_column :profile_layouts, :background_image, :string

  end

  def down

    remove_column :profile_layouts, :background_image
  end
end
