class Missile < ActiveRecord::Base
    belongs_to :game
    belongs_to :city

    def self.new_missile(city_obj)
        new_missile = Missile.new
        new_missile.city = city_obj
        new_missile.active = true
        new_missile.save
    end
    
    def self.find_active_by_city(city)
        Missile.where(["city_id = ? AND active = ?", city, true])
    end

    def self.find_active_by_city_range(min, max)
        Missile.where(['(city_id BETWEEN ? AND ?) AND (active = ?)' , min, max, true])
    end
end