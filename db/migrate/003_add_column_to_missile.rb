class AddColumnToMissile < ActiveRecord::Migration[5.0]

    def change 
        add_column :missiles, :game_id, :integer
    end 
end