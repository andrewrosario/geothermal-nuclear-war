class Game < ActiveRecord::Base
    has_many :missiles
    has_many :cities, through: :missiles

end