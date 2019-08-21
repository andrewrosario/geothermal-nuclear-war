require_relative "../config/environment"
user_kills = 0 
cpu_kills = 0
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
    puts "Shall we play a game,  #{name}..."
    name 
end 
def new_game(commander)
    nuke =  Game.new(player_name: commander)
    nuke.save
end 


def list_cities(plyer)
   City.all.where("player = ?", plyer)
#   usa2 = usa.collect {|city| city.name}
#     puts usa2
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
    n = 5 
    while n > 0 
        display(plyer)
        puts "You have #{n} missiles to deploy"
        puts "where would you like to deploy your missiles"
        input = gets.strip.to_i #make sure to add a parameter that limits the user only selecting 1-5 for both cities and missiles August 20end
        city_obj = City.all.find {|city| city.id == input}
        new_missile = Missile.new
        new_missile.city = city_obj
        new_missile.active = true
        new_missile.save
        n -= 1 
        
    end 
end
    
def launch
    
       
    display("user")
    puts "Please select a missile by city designation"
    selection = gets.strip.to_i 
    target_display
    puts "Please select the target you want to nuke"
    targeting = gets.strip.to_i
    current_missile = Missile.where(["city_id = ? AND active = ?", selection, true]).first 
      
       current_missile.dropped_on = targeting
       current_missile.active = false 
       current_missile.save
        puts "Hasta La Vista Baby"
    # user_kills += City.where("id = ?", targeting)[0].population
    
end 
launch 

    
