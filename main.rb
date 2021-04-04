require "csv"
quit = false 
users = CSV.open("users.csv", "a+")
user = {}

def login_details 
    puts "what is your username?"
    username = gets.chomp.downcase
    puts "what is your password?"
    password = gets.chomp.downcase
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
        input = gets.chomp
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
        end 
    end
    puts "what would you like to do?"
    puts "option: quit"
    input = gets.chomp
    if input == "quit"
        quit = true
    end
end