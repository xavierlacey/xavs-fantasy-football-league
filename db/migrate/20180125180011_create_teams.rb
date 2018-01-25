class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :transfers_remaining
      t.json :properties
      (1..38).to_a.map { |i| t.integer "points_in_gameweek_#{i}" }

      t.timestamps
    end
  end
end