# TERMINAL APPLICATION - HOW YOU DOIN?

# login
# Open external CSV file, login.csv
# Give user the login option
# Get user input. Username and Password
# Check if Username exits on the CSV file, login.csv
# If username is part of CVC file, login.csv, check if Password match with Username value
# If password match Username value, "Welcome" and present "Menu"
# If password does not match Username value, "Password Incorrect, try again", take back to user input
# If username is not part of CVC file, login.csv, "You don't have a account, sign up or try again" take back to user input
# Clear old commands before presenting "Menu"
# Clear old commands before presenting "Menu"

# quit = false 
# while !quit
#     input = gets.chomp
#     if input == "quit"
#         quit = true
#     end
# end 
users_array = []

until quit
    puts "options: [login, signup]"
    # signup 
    input = gets.chomp
    if input == "signup"
        puts "what is your username?"
        username = gets.chomp
        puts "what is your password?"
        password = gets.chomp 
        user = {}
        user[:username] = username
        user[:password] = password 
        users_array.push(user)
        File.open("users.csv", "a") {
            |file| file.append("#{username}, #{password}\n")
        } 
    elsif input == "login"
    end 
    # login
    puts "what would you like to do?"
    puts "options: quit"
    input = gets.chomp 