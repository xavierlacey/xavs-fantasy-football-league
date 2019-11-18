class AddStatusToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :status, :text
    add_column :players, :news, :text
    add_column :players, :chance_of_playing, :text
  end
end
