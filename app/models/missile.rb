class Missile < ActiveRecord::Base
    belongs_to :game
    belongs_to :city

end