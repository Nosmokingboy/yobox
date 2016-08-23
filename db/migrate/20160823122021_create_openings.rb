class CreateOpenings < ActiveRecord::Migration[5.0]
  def change
    create_table :openings do |t|
      t.integer :rating
      t.references :box, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
