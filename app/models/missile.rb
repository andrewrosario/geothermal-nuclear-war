require_relative 'game'
class Missile < ActiveRecord::Base
    belongs_to :game
    belongs_to :city

    def self.new_missile(city_obj)
        new_missile = Missile.new
        new_missile.city = city_obj
        new_missile.active = true
        new_missile.game_id = Game.last.id
        new_missile.save
    end
    
    def self.find_active_by_city(city)
        Missile.where(["city_id = ? AND active = ? AND game_id = ?", city, true, Game.last.id])
    end

    def self.find_active_by_city_range(min, max)
        Missile.where(['(city_id BETWEEN ? AND ?) AND (active = ?) AND (game_id = ?)' , min, max, true, Game.last.id])
    end

    def self.find_by_dropped_on(city_id)
        Missile.where('dropped_on = ? AND game_id = ?', city_id, Game.last.id)
    end
end