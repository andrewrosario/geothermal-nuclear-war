class CreateAllTables < ActiveRecord::Migration[5.0]
    def change
        create_table :cities do |c|
            c.string :name
            c.integer :population
            c.string :player
        end

        create_table :games do |g|
            g.string :player_name
        end

        create_table :missiles do |m|
            m.integer :city_id
            m.integer :dropped_on
            m.boolean :destroyed
        end
    end
end