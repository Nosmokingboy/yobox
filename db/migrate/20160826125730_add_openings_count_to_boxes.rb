class AddOpeningsCountToBoxes < ActiveRecord::Migration[5.0]

  def change
  change_table :boxes do |t|
    t.integer :openings_count, :integer, default: 0
  end

  reversible do |dir|
      dir.up { init_counter }
    end
  end

  def init_counter
    execute <<-SQL.squish
        UPDATE boxes
           SET openings_count = (SELECT count(1)
                                   FROM openings
                                  WHERE openings.box_id = boxes.id);
    SQL
  end

end
