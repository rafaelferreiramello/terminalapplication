require "csv"
require "tty-prompt"

quit = false 

prompt = TTY::Prompt.new

user = {}
posts = []
mood_feedback =  {
    Cheerful: ["Life is 10% what happens to me and 90% of how I react to it", "Go the extra mile. It’s never crowded there", "Believe you can and you’re halfway there", "Keep your face always toward the sunshine – and shadows will fall behind you", "Make each day your masterpiece"],
    Reflective: ["If you want to lift yourself up, lift up someone else", "You get in life what you have the courage to ask for", "We can’t help everyone, but everyone can help someone", "You must be the change you wish to see in this world", "None of us is as smart as all of us"],
    Melancholy: ["I can’t change the direction of the wind, but I can adjust my sails to always reach my destination", "Begin anywhere", "Whenever you find yourself doubting how far you can go, just remember how far you have come", "Do not wait; the time will never be just right", "Start where you are. Use what you have. Do what you can"],
    Angry: ["Nothing ever gets easier. You just get stronger", "I will allow life’s changes to make me better, not bitter", "Nobody can hurt me without my permission", "The best revenge is massive success", "The question isn’t who is going to let me; it’s who is going to stop me"],
    Lonely: ["The strongest men are the most alone", "Loneliness adds beauty to life. It puts a special burn on sunsets and makes night air smell better", "The more powerful and original a mind, the more it will incline towards the religion of solitude", "If you learn to really sit with loneliness and embrace it for the gift that it is… an opportunity to get to know you", "The soul that sees beauty may sometimes walk alone"]
}

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

def validate_input(message, incorrect_message)
    input = ""
    while input == ""
        print message 
        input = gets.chomp
        if input == ""
            puts incorrect_message
        end 
    end
    return input 
end 

until quit 
    line = find_user?("user1") # DEBUG 
    user[:username] = line[0] # DEBUG
    user[:password] = line[1] # DEBUG
    until user != {}
        puts "Login or Signup?"
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
            if line
                if line [1] == password
                    user[:username] = line[0]
                    user[:password] = line[1]
                    puts "you are logged in"
                end 
            end
            if user == {}
                puts "incorrect information, try again"
            end
        else
            puts "invalid option, try again"
        end
    end
    # menu = prompt.select("what would you like to do?", %w(Mood Chart Diary Exit))
    menu = "Chart" # DEBUG
    case menu
    when "Mood"
        mood_input = prompt.select("how are you feeling today?", %w(Cheerful Reflective Melancholy Angry Lonely))
        mood = mood_input.to_sym
        puts mood_feedback[mood].sample
        CSV.open("moods.csv", "a") do |csv|
            csv << [user[:username],mood_input]
        end
    when "Chart"
        chart_input = prompt.select("What would you like to check?", %w(Top1 Top3))
        charts = {}
        moods = CSV.open("moods.csv", "r").read
        moods.each do |mood| #[username, mood]
            if mood[0] == user[:username]
                charts[mood[1]] = 0 unless charts.include?(mood[1])
                charts[mood[1]] += 1
            end
        end
        new_chart = charts.sort_by {|k,v| v}.reverse
        case chart_input
        when "Top1"
            p new_chart
            puts "Your most frequently mood is #{new_chart[0][0]} and you told us that you were feeling like this #{new_chart[0][1]} times"
        when "Top3" 
            p new_chart
            puts "Your most frequently mood is #{new_chart[0][0]} and you told us that you were feeling like this #{new_chart[0][1]} times"
            puts "Your second most frequently mood is #{new_chart[1][0]} and you told us that you were feeling like this #{new_chart[1][1]} times"
            puts "Your third most frequently mood is #{new_chart[2][0]} and you told us that you were feeling like this #{new_chart[2][1]} times"
        end
    when "Diary"
        diary_input = prompt.select("What would you like to do?", %w(New Read Edit Delete))
        diary = diary_input
        case diary
        when "New"
            post = {
                user: user[:username],
                date: validate_input("Date(00/00/00):", "You must enter the date"),
                message: validate_input("Tell us your thoughts:", "You must enter a message")
            }
            posts.push({
                user: user[:username],
                date: post[:date],
                message: post[:message]
            })
            CSV.open("diary.csv", "a") do |csv|
                csv << [user[:username],post[:date],post[:message]]
            end
        when "Read"
            CSV.open("diary.csv", "r") do |csv|
                csv.each do |post|
                    if post[0] == user[:username]
                        puts "#{post[1]} you were feeling this: #{post[2]}"
                    end
                end
            end 
        when "Edit"
            CSV.open("diary.csv", "a+") do |csv|
                csv.each do |post|
                    if post[0] == user[:username]
                        puts "#{post[1]}"
                        posts.push(post)
                    end
                end
            end
            p posts
            input = validate_input("Which date would you like to change?", "You must enter a date")
            index = posts.index {|element| element[1] == input }
            post = posts[index]
            new_post = {
                date: validate_input("Date(00/00/00):", "You must enter the date"),
                message: validate_input("Tell us your thoughts:", "You must enter a message")
            }
            posts[index] = new_post
            p new_post
        when "Delete"
            CSV.open("diary.csv", "a+") do |csv|
                csv.each do |post|
                    if post[0] == user[:username]
                        puts "#{post[1]}"
                        posts.push(post)
                    end
                end
            end
            # p posts
            input = validate_input("Which date would you like to delete?", "You must enter a date")
            index = posts.index {|element| element[1] == input }
            posts.delete_at(index)
        end
    when "Exit"
        quit = true
    end
end

# CSV.open("diary.csv", "w") do |csv|
#     posts.each do |post|
#         csv << [user[:username],post[:date],post[:message]]
#     end
# end

















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