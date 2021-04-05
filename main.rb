require "csv"
require "tty-prompt"

quit = false 
users = CSV.open("users.csv", "a+")
user = {}

def login_details 
    puts "what is your username?"
    username = gets.chomp
    puts "what is your password?"
    password = gets.chomp
    return username, password
end

def find_user?(username)
    CSV.open("users.csv", "a+") do |csv|
        csv.each do |line|
            if line[0] == username 
                return line
            end 
        end 
        return false
    end
end

def write_csv(username, password) 
    CSV.open("users.csv", "a") do |csv|
        csv << [username, password]
    end
end

until quit 
    until user != {}
        puts "options: [login, signup]"
        input = gets.chomp.downcase
        if input == "signup"
            username, password = login_details()
            username_is_taken = find_user?(username)
            if username_is_taken == false
                write_csv(username, password)
                user[:username] = username
                user[:password] = password 
                puts "you are logged in"
            end
        elsif input == "login"
            username, password = login_details()
            line = find_user?(username)
            if line [1] == password
                user[:username] = line[0]
                user[:password] = line[1]
                puts "you are logged in"
            end 
            if user == {}
                puts "incorrect information, try again"
            end
        else
            puts "invalid option, try again"
        end
    end
    prompt = TTY::Prompt.new
    menu = prompt.select("what would you like to do?", %w(Mood Chart Diary Exit))
        if menu == "Mood"
            puts "mood"
        elsif menu == "Chart"
            puts "chart"
        elsif menu == "Diary"
            puts "diary"
        else menu == "Exit"
            quit = true
        end 
end
