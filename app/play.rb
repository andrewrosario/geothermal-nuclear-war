require_relative "../config/environment"
user_kills = 0 
cpu_kills = 0
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

def welcome 
    puts "Welcome to War Games"
end 

def ask_user 
    puts "Please Enter Name"
    name = gets.strip 
    puts "Shall we play a game,  #{name}..."
    name 
end 

def new_game(commander)
    nuke = Game.new(player_name: commander)
    nuke.save
end 

def list_cities(plyer)
   City.all.where("player = ?", plyer)
# usa2 = usa.collect {|city| city.name}
# puts usa2
end 

def assign_missiles(plyer)
    big_array = []
    big_array = list_cities(plyer).collect do |city| 
        array = [] 
        array << city.id
        array << city.name 
        array << Missile.where(["city_id = ? AND active = ?", city, true]).count 
    end 
end

def display(plyer)
    rows = assign_missiles(plyer)
    table = Terminal::Table.new :rows => rows
    puts table 
end 

def target_display
    big_array = list_cities("computer").collect do |city|
        array = []
        array << city.id
        array << city.name 
    end 
    table = Terminal::Table.new :rows => big_array
    puts table
end

def build_missiles(plyer)
    player_name = Game.last.player_name
    n = 5 
    puts "#{player_name}, you are now able to create your nuclear arsenal."
    puts "You will build an ICBM by assigning that missile to a city." 
    puts "Select a city by entering the number associate with that city."
    while n > 0 
        display(plyer)
        puts "You have #{n} missiles to deploy"
        puts "Where would you like to deploy your missiles?"
        input = gets.strip.to_i #make sure to add a parameter that limits the user only selecting 1-5 for both cities and missiles August 20end
        create_missile(input)
        n -= 1 
    end 
end

def create_missile(input)
    city_obj = City.all.find {|city| city.id == input}
    new_missile = Missile.new
    new_missile.city = city_obj
    new_missile.active = true
    new_missile.save
end
    
def launch
    display("user")
    puts "Please select a missile by city designation"
    selection = gets.strip.to_i 
    target_display
    puts "Please select the target you want to nuke"
    targeting = gets.strip.to_i
    missile_away(selection, targeting)
    puts "Hasta La Vista Baby"
    # user_kills += City.where("id = ?", targeting)[0].population
end

def missile_away(selection, targeting)
    current_missile = Missile.where(["city_id = ? AND active = ?", selection, true]).first 
    current_missile.dropped_on = targeting
    current_missile.active = false 
    current_missile.save
end

def computer_missiles
    5.times do
        create_missile(rand(6..10))
    end
end

def computer_launch
    from_city = rand(6..10)
    to_city = rand(1..5)
    missile_away(from_city, to_city)
end

build_missiles('user')
binding.pry
puts "done"

    
