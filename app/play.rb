require "../config/environment"

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


def list_cities
    sql =<<-SQL
    SELECT * 
    FROM cities
    SQL
binding.pry 
end 

________________


    
