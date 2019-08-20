class Game < ActiveRecord::Base
    
    attr_reader :name
    has_many :missiles
    has_many :cities, through: :missiles
    def initialize(name)
        @name = name

    end 
end