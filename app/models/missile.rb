class Missile < ActiveRecord::Base
    belongs_to :game
    belongs_to :city

    def self.new_missile(city_id, dropped_on = nil, active = true)
        new_missile = Missile.new(city_id: city_id, dropped_on: dropped_on, active: active )
        new_missile.save
        
    end
    
end