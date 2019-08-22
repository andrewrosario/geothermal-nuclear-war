require_relative "../config/environment"
require_relative 'ascii-images'

cpu_kills = []
user_kills = []
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

def separate_comma(number)
    number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
end

def music 
    pid = fork{ exec 'afplay', "balloonsong.mp3" }
end 

def welcome
    banner
    puts "Welcome to War Games"
end 

def ask_user 
    puts "Please Enter Name"
    name = gets.strip 
    puts "Shall we play a game, #{name}?"
    puts "You may (q)uit playing at any time."
    name 
end 

def new_game(commander)
    a_game = Game.new(player_name: commander)
    player_name = commander
    a_game.save
end 

def row_array(city)
    array = []
    array << city.id
    array << city.name 
end

def count_missiles_by_city(plyer)
    big_array = City.list_cities(plyer).collect do |city| 
        array = row_array(city)
        array << Missile.find_active_by_city(city).count 
    end 
end

def user_display
    rows = count_missiles_by_city("user")
    table = Terminal::Table.new :title => "Choose a Launch Site", :headings => ['', 'City Name', 'Number of Missiles'], :rows => rows
    puts table 
end 

def target_display
    big_array = City.list_cities("computer").collect do |city|
        array = row_array(city)
        array << separate_comma(city.population)
        if Missile.find_by_dropped_on(city.id) != []
            array << "Destroyed"
        else
            array << ""
        end
    end 
    table = Terminal::Table.new :title => "Choose a Target", :headings => ['', 'City Name', 'Population', 'Status'], :rows => big_array
    puts table
end

def build_missiles
    n = 5 
    puts "You are now able to create your nuclear arsenal."
    puts "You will build an ICBM by assigning that missile to a city." 
    puts "Select a city by entering the number associated with that city."
    while n > 0 
        print "\e[2J\e[f"
        banner
        user_display
        puts "You have #{n} missiles to deploy"
        puts "Where would you like to deploy your missiles?"
        input = give_up(gets.strip)
        until input.between?(City.id_array('user').min, City.id_array('user').max)
            puts "You must select one of your own cities"
            puts "Where would you like to deploy your missiles?"
            input = give_up(gets.strip)
        end
        create_missile(input)
        n -= 1 
    end 
end

def create_missile(input)
    city_obj = City.find_by_id(input)
    Missile.new_missile(city_obj)
end

def limit_input(input, player)
    min = City.id_array(player).min
    max = City.id_array(player).max
    until input.between?(min..max)
        puts "Invalid selection. Try again."
        input = give_up(gets.strip)
    end
    input
end
    
def launch(user_kills)
    print "\e[2J\e[f"
    sleep(1)
    user_display
    puts "Please select a city from which to launch your missile."
    selection = give_up(gets.strip)
    until Missile.all.find {|m| m.city_id == selection && m.active == true && m.game_id == Game.last.id}
        puts "That city has no missiles."
        puts "Please select a city from which to launch your missile."
        selection = give_up(gets.strip)
    end
    print "\e[2J\e[f"
    target_display
    puts "Please select the target you want to nuke."
    targeting = give_up(gets.strip)
    until Missile.find_by_dropped_on(targeting).length == 0 && targeting.between?(City.id_array('computer').min, City.id_array('computer').max)
        puts "You have already killed everyone in that city or your input is invalid."
        puts "Please select the target you want to nuke."
        targeting = give_up(gets.strip)
    end
    missile_away(selection, targeting)
    user_kills << user_report_results(targeting)
end

def missile_away(selection, targeting)
    current_missile = Missile.find_active_by_city(selection).first 
    current_missile.dropped_on = targeting
    current_missile.active = false 
    current_missile.save
end

def computer_missiles
    min = City.id_array('computer').min
    max = City.id_array('computer').max
    5.times do
        create_missile(rand(min..max))
    end
end

def computer_launch(score)
    # puts "Computer attacking --------------------------------------------------------------------------------------"
    from_min = City.id_array('computer').min
    from_max = City.id_array('computer').max
    from_array = Missile.find_active_by_city_range(from_min, from_max).map {|m| m.city_id}
    
    to_min = City.id_array('user').min
    to_max = City.id_array('user').max
    to_array = (to_min..to_max).to_a

    # puts "To_Array is #{to_array}"
    # puts "From_Array is #{from_array}"
    if to_array.length > 0 && from_array.length > 0
        # puts "IF!!!!"
        from_city = from_array.delete(from_array.sample)
        to_city = to_array.delete(to_array.sample)
        until !Missile.all.find {|m| m.dropped_on == to_city && m.game_id == Game.last.id}
            to_city = to_array.delete(to_array.sample)
        end
        # puts 'end until'
        missile_away(from_city, to_city)
        score << cpu_report_results(to_city)
        sleep(3)
    end
    # puts "End Attack---------------------------------------------------------------------------------------------------"
end

def user_report_results(target)
    city = City.where("id = ?", target).first
    puts "You have successfully bombed #{city.name}."
    puts "You have killed #{separate_comma(city.population)} people and destroyed #{count_and_destroy_missiles(target)} missiles."
    city.population
end

def cpu_report_results(target)
    city = City.where("id = ?", target).first
    puts "The USSR has bombed #{city.name}."
    puts "They have killed #{separate_comma(city.population)} people and destroyed #{count_and_destroy_missiles(target)} missiles."
    if target == 4
        puts "...and 3 Walmarts."
    end
    city.population
end

def give_up(input)
    if input.to_s.downcase == 'q'
        puts won
        puts winningmove
        exit!
    else 
        input.to_i
    end
end 

def usernum_missiles
    stockpile = Missile.find_active_by_city_range(City.id_array('user').min, City.id_array('user').max)
    stockpile.length
end

def cpunum_missiles
    stockpile = Missile.find_active_by_city_range(City.id_array('computer').min, City.id_array('computer').max)
    stockpile.length
end 

def gameover(user_kills, cpu_kills)
    if usernum_missiles == 0 || cpunum_missiles == 0 
        puts "You have missiles #{usernum_missiles} remaining and USSR has missiles remaining #{cpunum_missiles}"
        final_score(user_kills, cpu_kills)
        overhead
        puts "Would you like to play again?"
        answer = gets.strip 
            until answer.downcase == "yes" || answer == "no" do
                puts "Please answer yes or no." 
                answer = gets.strip
            end
        if answer == "yes"
            run
        else answer == "no"
            exit!
        end 
    else
        puts "You have #{usernum_missiles} left! DEFCON 1!"
    end
end

def final_score(user_kills, cpu_kills)
    rows = [[separate_comma(user_kills.sum), separate_comma(cpu_kills.sum)]]
    table = Terminal::Table.new :headings => ['Player Kills', 'CPU Kills'], 
    :rows => rows, :style => {:width => 80}
    puts table
end

def count_and_destroy_missiles(target)
    how_many = Missile.find_active_by_city(target).count
    Missile.find_active_by_city(target).update_all(active: false)
    how_many
end

def run 
    music
    user_kills = []
    cpu_kills = []
    welcome 
    new_game(ask_user)
    build_missiles
    computer_missiles
    sleep(1)
    puts "Now that all your missiles have been deployed, you may begin your attack."
    until gameover(user_kills, cpu_kills) == true 
        puts "New Round!"
        launch(user_kills)
        sleep(1)
        computer_launch(cpu_kills)
        puts ''
    end
    final_score(user_kills, cpu_kills)   
end


run 

    
