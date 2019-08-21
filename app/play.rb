require_relative "../config/environment"

user_kills = []
cpu_kills = []
player_name = "Mr. President"

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

def separate_comma(number)
    number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
end

def welcome 
    banner = "'

        . _..::__:  ,- -._       |7             _.__             
        _.___ _ _<_>`!(._`.`-.    /        _._      _ ,_/     -._.---.-.__
    .{     " " `-==,' ._\{  \  / {)     / _ >_-                  mt-2_
    \_.:--.       `._ )`^- -      , [_/(                       __/- 
            \              _L       oD_,--                 )     /. (|   
            |           .'         _)_.\\._<> 6              _, /     
            `.         /          [_/_ ` ` (                < }  )      
                \\    .-. )          /   `-...' `:._          _)         
        `        \  (  `(          /         `:\  > \  ,-^.  /          
                ` _,   -        |           \`'   \|   ?_)  {\         
                    `=.---.       `._._       ,'    "'   |   -  .        '
                    '   |    `-._        |     /           : <_|h--._      
                        (        >       .     | ,           =.__. - \     
                        `.     /        |     |{|               -. \     .
                        |   '       '   \   / `' '            _     \     
                    ''    |  /             |_'    '            |  __  /     
                        | |                               '  '-'   '-    \.
    "                   |/     '                                   '     / '
                                                                        
                                                                        
                        
    puts banner 
    puts "Welcome to War Games"
end 

def ask_user 
    puts "Please Enter Name"
    name = gets.strip 
    puts "Shall we play a game, #{name}..."
    name 
end 

def new_game(commander)
    nuke = Game.new(player_name: commander)
    player_name = commander
    nuke.save
end 

def list_cities(plyer)
   City.all.where("player = ?", plyer)
end 

def row_array(city)
    array = []
    array << city.id
    array << city.name 
end

def assign_missiles(plyer)
    big_array = list_cities(plyer).collect do |city| 
        array = row_array(city)
        array << Missile.where(["city_id = ? AND active = ?", city, true]).count 
    end 
end

def display_city
    pic = "
    __    __                        ___      _
    |  |  |  |       /|             |   |   _/ \_
    |  |  |  |   _  | |__           |   |_-/     \-  _ _
    |__|  |  |  |_| | | |  |/\_     |   |  \     /  |___|
    |  |  |  |  | | __| |  |   |_   |   |   |___|   |   |
    |  |  |^ |  | ||  | |  |   | |__|   |   |   |   |   |
    |  |  |  |  | ||  | |  |   |/\  |   |   |   |   |   |
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~/  \~~~~~~~~~~~~~~~~~~~~~~~
    ~ ~~  ~ ~~ ~~~ ~ ~ ~~ ~~ ~~ \   \__   ~  ~  ~~~~ ~~~ ~~
    ~~ ~ ~ ~~~ ~~  ~~ ~~~~~~~~~~ \   \o\  ~~ ~ ~~~~ ~ ~ ~~~
    ~ ~~~~~~~~ ~ ~ ~~ ~ ~ ~ ~ ~~~ \   \o\=   ~~ ~~  ~~ ~ ~~
    ~ ~ ~ ~~~~~~~ ~  ~~ ~~ ~ ~~ ~ ~ ~~ ~ ~ ~~ ~~~ ~ ~ ~ ~ ~~~~"
    puts pic
end

def user_display
    rows = assign_missiles("user")
    table = Terminal::Table.new :headings => ['', 'City Name', 'Number of Missiles'], :rows => rows
    puts table 
end 

def target_display
    big_array = list_cities("computer").collect do |city|
        array = row_array(city)
        array << city.population
    end 
    table = Terminal::Table.new :headings => ['', 'City Name', 'Population'], :rows => big_array
    puts table
end

def build_missiles
    n = 5 
    puts "You are now able to create your nuclear arsenal."
    puts "You will build an ICBM by assigning that missile to a city." 
    puts "Select a city by entering the number associated with that city."
    while n > 0 
        user_display
        puts "You have #{n} missiles to deploy"
        puts "Where would you like to deploy your missiles?"
        input = give_up(gets.strip)
        until input.between?(1,5)
            puts "You must select one of your own cities"
            puts "Where would you like to deploy your missiles?"
            input = give_up(gets.strip)
        end
        create_missile(input)
        n -= 1 
    end 
    user_display
end

def create_missile(input)
    city_obj = City.all.find {|city| city.id == input}
    new_missile = Missile.new
    new_missile.city = city_obj
    new_missile.active = true
    new_missile.save
end
    
def launch
    user_display
    puts "Please select a missile by city designation"
    selection = input = give_up(gets.strip)
    until Missile.all.find {|m| m.id == selection}
        puts "That city has no missiles."
        puts "Please select a city from which to launch your missile."
        selection = gets.strip.to_i 
    end
    target_display
    puts "Please select the target you want to nuke"
    targeting = input = give_up(gets.strip)
    until !Missile.all.find {|m| m.dropped_on == targeting}
        puts "You have already killed everyone in that city"
        puts "Please select the target you want to nuke"
        targeting = input = give_up(gets.strip)
    end
    missile_away(selection, targeting)
    report_results(targeting)
end

def missile_away(selection, targeting)
    current_missile = Missile.where(["city_id = ? AND active = ?", selection, true]).first 
    current_missile.dropped_on = targeting
    current_missile.active = false 
    current_missile.save
end

def computer_missiles
    min = City.where("player = ?", "computer").min.id
    max = City.where("player = ?", "computer").max.id
    5.times do
        create_missile(rand(min..max))
    end
end

def computer_launch(score)
    from_min = City.where("player = ?", "computer").min.id
    from_max = City.where("player = ?", "computer").max.id
    from_array = Missile.where(['(city_id BETWEEN ? AND ?) AND (active = ?)' , from_min, from_max, true]).map {|m| m.city_id}
    to_min = City.where("player = ?", "user").min.id
    to_max = City.where("player = ?", "user").max.id
    from_city = from_array.delete(from_array.sample)
    to_city = rand(to_min..to_max)
    missile_away(from_city, to_city)
    score << report_results(to_city)
end

def report_results(target)
    city = City.where("id = ?", target).first
    puts "You have successfully bombed #{city.name}."
    puts "You have killed #{separate_comma(city.population)} people and destroyed #{count_and_destroy_missiles(target)} missiles."
    city.population
end

def current_score(kills)
    puts kills.sum
end

def give_up(input)
    input.to_s.downcase == 'q'? exit! : input.to_i
end 

def count_and_destroy_missiles(target)
    how_many = Missile.where(["city_id = ? AND active = ?", target, true]).count
    Missile.where(["city_id = ? AND active = ?", target, true]).update_all(active: false)
    how_many
end


binding.pry
puts "done"

    
