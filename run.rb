require_relative "app/play"
require_relative "config/environment"
def run 
    user_kills = []
    cpu_kills = []
    welcome 
    new_game(ask_user)
    display_city
    build_missiles
    computer_missiles
    until gameover == true 
        launch 
        computer_launch if gameover == false
    end
end

run 
