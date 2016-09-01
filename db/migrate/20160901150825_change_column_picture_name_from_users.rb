class ChangeColumnPictureNameFromUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :facebook_picture_url, :picture
  end
end
