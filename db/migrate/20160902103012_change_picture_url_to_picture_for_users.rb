class ChangePictureUrlToPictureForUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :picture_url, :picture
  end
end
