# gems and dependencies
require "csv"
require "tty-prompt"
require "tty-table"
require "tty-font"
require "colorize"
require "pastel"
require_relative "./methods.rb"

# Command Line Argument - Instructions on how to use the application
if ARGV.include? "--help"
    puts "Here is how you use How You Doing?:"
    puts "Choose between login or signup"
    puts "Add your username and password"
    puts "Choose between mood, chart or diary"
    puts "For mood, select how you are feeling today and get inspired"
    puts "For chart, select between Top1, Top3 or Table"
    puts "For diary, select between New, Read, Edit or Delete"
    puts "To exit the application choose Exit on home menu"
    puts "Any question, hit us on Github: github.com/howyoudoing"
    puts "Thank you for your support!"
    exit
end

# clear terminal from previous command and display title
clear_and_title

# loop to put the functions together
quit = false 
user = {}
until quit 
    until user != {}
        puts "Login or Signup?"
        input = gets.chomp.downcase
        # signup
        if input == "signup"
            username, password = login_details()
            username_is_taken = find_user?(username)
            # username doesn't exist in the database
            if username_is_taken == false
                write_csv(username, password)
                user[:username] = username
                user[:password] = password 
                clear_and_title
                puts "You are logged in".cyan
            else
                # username exists in the database
                clear_and_title
                puts "Username taken, try again".red
            end
        # login
        elsif input == "login"
            username, password = login_details()
            line = find_user?(username)
            # username exists in the database check password
            if line
                if line [1] == password
                    user[:username] = line[0]
                    user[:password] = line[1]
                    clear_and_title
                    puts "You are logged in".cyan
                end 
            end
            # username doesn't exist in the database
            if user == {}
                clear_and_title
                puts "Incorrect information, try again".red
            end
        else
            # users who did not understand the instructions
            clear_and_title
            puts "Invalid option, try again".red
        end
    end
    # main menu
    begin
        prompt = TTY::Prompt.new
        menu = prompt.select("What would you like to do?", %w(Mood Chart Diary Exit))
    rescue
        puts "You need to run in your terminal 'bundle install'."
    end
    # case loop to put together the features
    case menu
    when "Mood"
        clear_and_title
        mood_input = prompt.select("How are you feeling today?", %w(Cheerful Reflective Melancholy Angry Lonely))
        mood = mood_input.to_sym
        puts feedback_moods[mood].sample.colorize(:magenta)
        # saving in the CSV file 
        CSV.open("moods.csv", "a") do |csv|
            csv << [user[:username],mood_input]
        end
    when "Chart"
        clear_and_title
        chart_input = prompt.select("What would you like to check?", %w(Top1 Top3 Table Back))
        charts = {}
        moods = CSV.open("moods.csv", "r").read
        # counting the number of inputs, but only for the user's mood logged
        moods.each do |mood| 
            if mood[0] == user[:username]
                charts[mood[1]] = 0 unless charts.include?(mood[1])
                charts[mood[1]] += 1
            end
        end
        # putting data in descending order
        new_chart = charts.sort_by {|k,v| v}.reverse
        # error handling in case user does not have enough inputs for the feature
        case chart_input
        when "Top1"
            begin 
                puts "Your most frequently mood is #{new_chart[0][0]} and you told us that you were feeling like this #{new_chart[0][1]} time(s)".light_blue
            rescue
                puts "You don't have enough inputs to create a Top1, share more how you are feeling and try again".red
            end        
        when "Top3" 
            begin 
                puts "Your most frequently mood is #{new_chart[0][0]} and you told us that you were feeling like this #{new_chart[0][1]} time(s)".cyan
                puts "Your second most frequently mood is #{new_chart[1][0]} and you told us that you were feeling like this #{new_chart[1][1]} time(s)".light_blue
                puts "Your third most frequently mood is #{new_chart[2][0]} and you told us that you were feeling like this #{new_chart[2][1]} time(s)".blue
            rescue
                puts "You don't have enough inputs to create a Top3, share more how you are feeling and try again".red
            end
        when "Table"
            begin 
                table = TTY::Table.new(["Mood", "Amount"], new_chart)
                puts table.render(:basic).light_cyan
            rescue
                puts "You don't have enough inputs to create a table, share more how you are feeling and try again".red
            end    
        when "Back"
        end
    when "Diary"
        clear_and_title
        read_posts = CSV.open("diary.csv", "r").read
        # setting time right now
        time = Time.new
        time = "#{time.day}/#{time.month}/#{time.year}"
        diary_input = prompt.select("What would you like to do?", %w(New Read Edit Delete Back))
        case diary_input
        when "New"
            # setting what will be inside the post
            post = {
                user: user[:username],
                date: time,
                message: validate_input("Tell us your thoughts:", "You must enter a message")
            }
            # pushing to the array
            read_posts.push([
                user[:username],
                post[:date],
                post[:message]
            ])
            # appending to the CSV file
            CSV.open("diary.csv", "a") do |csv|
                csv << [user[:username],post[:date],post[:message]]
            end
        when "Read"
            # reading and displaying CSV file content
            read_posts.each do |post|
                    if post[0] == user[:username]
                        puts "#{post[1]} you were feeling this: #{post[2]}"
                    end
            end 
        when "Edit"
            # get all user's logged entries
            posts = []
            # get all entries 
            all_posts = []
            # identifying and pushing to the correct array
            read_posts.each do |post|
                    if post[0] == user[:username]
                        posts.push(post)
                    else 
                        all_posts.push(post)
                    end
            end
            # display date entries
            posts.each_with_index do |post, index|
                puts "#{index}. #{post[1]} - #{post[2]}"
            end
            # get user input
            puts "Could you please input the number you wish to update:"
            update_post = gets.chomp.to_i
            # error handling if user enters non-existent data
            begin
                # new post
                post = {
                    user: user[:username],
                    date: posts[update_post][1],
                    message: validate_input("Tell us your thoughts:", "You must enter a message")
                }
                posts.push([
                    user[:username],
                    post[:date],
                    post[:message]
                ])
                # delete old one
                posts.delete_at(update_post)
                # put arrays together
                all_posts.concat(posts)
                # write in the CSV file
                CSV.open("diary.csv", "w") do |csv|
                    all_posts.each do |post|
                        csv << [post[0],post[1],post[2]]
                    end
                end
            rescue
                puts "Invalid entry, try again".red
            end
        when "Delete"
            posts = []
            all_posts = []
            read_posts.each do |post|
                    if post[0] == user[:username]
                        posts.push(post)
                    else 
                        all_posts.push(post)
                    end
            end
            
            posts.each_with_index do |post, index|
                puts "#{index}. #{post[1]} - #{post[2]}"
            end

            puts "Could you please input the number you wish to delete:"
            update_post = gets.chomp.to_i
            posts.delete_at(update_post)

            all_posts.concat(posts)

            CSV.open("diary.csv", "w") do |csv|
                all_posts.each do |post|
                    csv << [post[0],post[1],post[2]]
                end
            end
        when "Back"
            clear_and_title
        end
    when "Exit"
        quit = true
        system "clear"
    end
end


















# csv << diary_entry

# diary = []
# CSV.open...... do |csv|
#     csv.each {|line|
#         if line[0] == user[:id]
#             # diary.push(line) # line is a array
#             # diary.push({
#             #    date: line[1],
#             #    message: line[2]
#             # })
#         end
#     }
# end

# mood_list = []
# CSV.open...... do |csv|
#     csv.each {|line|
#         if line[0] == user[:id]
#             # mood_list.push(line) # line is a array
#             # mood_list.push({
#             #    date: line[1],
#             #    mood: line[3]
#             # })
#         end
#     }
# end

# diary.each do |entry| #entry is an array
#     # "date, I'm sad today"
#     puts entry[1], entry[2]
# end


# diary.each do |entry| #entry is a hash
#     # "date, I'm sad today"
#     puts entry[:date], entry[:message]
# end

# # graph daily mood
# mood_list.each do |entry|
#     puts entry[:mood]
# end12/08/21, Im feeling great






# users = []
# def find_user?(username, users_array)
#     # CSV.open("users.csv", "a+") do |csv|
#         users_array.each do |line|
#             if line[0] == username 
#                 return line
#             end 
#         end 
#         return false
#     # end
# end

# user[:mood] = "cheerful"

# # array, index, new_value
# index = users.find_index where username is equal to user[:name]
# users[index] = user

# append, write, read

# CSV.open(path, "a").... 
#     csv << users
#       users.each do |user|
#           csv << [user[:name],user[:password],user[:mood]]
#       end
# end






# users = CSV.open("users.csv", "r").read

# p users
# # array, index, new_value
# users[1][2] = "Angry"
# puts users[1][2]
# p users




# CSV.open("users.csv", :headers => true).each do |line|
#     p line
# end