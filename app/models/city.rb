class City < ActiveRecord::Base
    has_many :missiles
    has_many :games, through: :missiles

    def self.new_city(name, population, player)
        new_city = City.new(name: name, population: population, player: player )
        new_city.save
    end

    def self.list_cities(plyer)
        City.all.where("player = ?", plyer)
    end 

    def self.find_by_id(id)
        City.all.find {|city| city.id == id}
    end

    def self.select_city_by_player(player)
        City.where("player = ?", player)
    end

    def self.id_array(player)
        my_cities = City.all.select {|c| c.player == player}
        my_cities.map {|c| c.id}
    end
end