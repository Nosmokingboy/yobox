class CreateBoxes < ActiveRecord::Migration[5.0]
  def change
    create_table :boxes do |t|
      t.string :title
      t.string :content
      t.float :latitude
      t.float :longitude
      t.datetime :expiration_date_time
      t.string :icon
      t.integer :openings_max
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
