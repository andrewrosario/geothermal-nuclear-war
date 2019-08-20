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


def list_cities(plyer)
   City.all.where("player = ?", plyer)
#   usa2 = usa.collect {|city| city.name}
#     puts usa2
end 

def assign_missiles(plyer)
    big_array = []
    i = 0
    big_array = list_cities(plyer).collect do |city| 
        array = [] 
        array << i + 1 
        i = i + 1 
        array << city.name 
        array << 0 
        
    end 
    
end
def display(plyer)
# table = Terminal::Table.new do |t|
#     t.rows = assign_missiles(plyer)
    
# end
rows = assign_missiles(plyer)
table = Terminal::Table.new :rows => rows
puts table 

end 
def build_missiles(plyer)
    n = 5 
    puts "You have #{n} missiles to deploy"
    puts "where would you like to deploy your missiles"
    input = gets.strip
    index = input.to_i - 1  
    city_name = assign_missiles(plyer)[index][1]
    city_obj = City.all.find {|city| city.name == city_name}
    new_missile = Missile.new_missile(city_obj)
    
    binding.pry
    #make sure to add a parameter that limits the user only selecting 1-5 for both cities and missiles August 20
end
build_missiles("user")






    
