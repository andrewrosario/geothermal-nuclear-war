class City < ActiveRecord::Base
    has_many :missiles
    has_many :games, through: :missiles

    def self.new_city(name, population, player)
        new_city = City.new(name: name, population: population, player: player )
        new_city.save
        
    end
end