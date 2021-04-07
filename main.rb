require "csv"
require "tty-prompt"

# CSV.open("users.csv", :headers => true).each do |line|
#     p line
# end

quit = false 
# users = CSV.open("users.csv", "r").read

# p users
# # array, index, new_value
# users[1][2] = "Angry"
# puts users[1][2]
# p users
moods = CSV.open("moods.csv", "a+")
diary = CSV.open("diary.csv", "a+")
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
        case menu
        when "Mood"
            mood_input = prompt.select("how are you feeling today?", %w(Cheerful Reflective Melancholy Angry Lonely))
            # mood = mood_input
            mood = mood_input.to_sym
            puts mood_feedback[mood].sample
            # case mood
            #     when "Cheerful"
            #         puts mood_feedback[:Cheerful].sample
            #         # CSV.open("moods.csv", "a") do |csv|
            #         #     csv << [mood]
            #         # end
            #     when "Reflective"
            #         puts mood_feedback[:Reflective].sample
            #         # CSV.open("moods.csv", "a") do |csv|
            #         #     csv << [mood]
            #         # end
            #     when "Melancholy"
            #         puts mood_feedback[:Melancholy].sample
            #         # CSV.open("moods.csv", "a") do |csv|
            #         #     csv << [mood]
            #         # end
            #     when "Angry"
            #         puts mood_feedback[:Angry].sample
            #         # CSV.open("moods.csv", "a") do |csv|
            #         #     csv << [mood]
            #         # end
            #     when "Lonely"
            #         puts mood_feedback[:Lonely].sample
            #         # CSV.open("moods.csv", "a") do |csv|
            #         #     csv << [mood]
            #         # end
            #     end
                CSV.open("moods.csv", "a") do |csv|
                    csv << [mood_input]
                end
        when "Chart"
            chart_input = prompt.select("What would you like to check?", %w(Week Month))
            chart = chart_input
            case chart
            when "Week"
                CSV.open("moods.csv", "r") do |csv|
                    puts csv.each
                end
            when "Month" 
                puts "month"
            end
        when "Diary"
            diary_input = prompt.select("What would you like to do?", %w(New Read Edit Delete))
            diary = diary_input
            case diary
            when "New"
                post = {
                    date: validate_input("Date(00/00/00):", "You must enter the date"),
                    message: validate_input("Tell us your thoughts:", "You must enter a message")
                }
                posts.push({
                    date: post[:date],
                    message: post[:message]
                })
                CSV.open("diary.csv", "a") do |csv|
                    csv << [post[:date],post[:message]]
                end
            when "Read"
                CSV.open("diary.csv", "r") do |csv|
                    csv.each do |post|
                        puts "#{post[0]} you were feeling this: #{post[1]}"
                    end
                end 
            when "Edit"
                CSV.open("diary.csv", "a+") do |csv|
                    csv.each do |post|
                        puts "#{post[0]}"
                    end
                end
                input = validate_input("Which date would you like to change?", "You must enter a date")
                index = posts.index {|element| element[:date] == input }
                post = posts[index]
                new_post = {
                    date: validate_input("Date(00/00/00):", "You must enter the date"),
                    message: validate_input("Tell us your thoughts:", "You must enter a message")
                }
                posts[index] = new_post
            when "Delete"
                puts "delete"
            end
        when "Exit"
            quit = true
        end 
end