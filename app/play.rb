require_relative "models/city"
require_relative "models/missile"
require_relative "models/game"
require "config/environment"

def welcome 
    puts "Welcome to War Games"
end 

def ask_user 
    puts "Please Enter Name"
    name = gets.strip 
    puts "Shall we play a game,  #{name}..."
    name 
end 
def new_game(name)
   nuke =  Game.new(name)
    nuke.save
end 
binding.pry
______________    