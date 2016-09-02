class ChangePictureToPictureUrlForUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :picture, :picture_url
  end
end
