class Missile < ActiveRecord::Base
    belongs_to :game
    belongs_to :city

    def self.new_missile(city_id, dropped_on, destroyed)
        new_missile = Missile.new(city_id: city_id, dropped_on: dropped_on, destroyed: destroyed )
        new_missile.save
        
    end
    
end