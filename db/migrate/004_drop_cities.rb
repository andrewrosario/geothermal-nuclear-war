class DropCities < ActiveRecord::Migration[5.0]

    def change 
        drop_table :cities

        create_table :cities do |c|
            c.string :name
            c.integer :population
            c.string :player
        end
    end
end