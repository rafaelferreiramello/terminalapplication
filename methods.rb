def clear_and_title
    font = TTY::Font.new(:doom)
    pastel = Pastel.new
    system "clear"
    puts pastel.cyan(font.write("HOW YOU DOIN?", letter_spacing: 2))
end

def feedback_moods
    mood_feedback =  {
        Cheerful: ["Life is 10% what happens to me and 90% of how I react to it", "Go the extra mile. It’s never crowded there", "Believe you can and you’re halfway there", "Keep your face always toward the sunshine – and shadows will fall behind you", "Make each day your masterpiece"],
        Reflective: ["If you want to lift yourself up, lift up someone else", "You get in life what you have the courage to ask for", "We can’t help everyone, but everyone can help someone", "You must be the change you wish to see in this world", "None of us is as smart as all of us"],
        Melancholy: ["I can’t change the direction of the wind, but I can adjust my sails to always reach my destination", "Begin anywhere", "Whenever you find yourself doubting how far you can go, just remember how far you have come", "Do not wait; the time will never be just right", "Start where you are. Use what you have. Do what you can"],
        Angry: ["Nothing ever gets easier. You just get stronger", "I will allow life’s changes to make me better, not bitter", "Nobody can hurt me without my permission", "The best revenge is massive success", "The question isn’t who is going to let me; it’s who is going to stop me"],
        Lonely: ["The strongest men are the most alone", "Loneliness adds beauty to life. It puts a special burn on sunsets and makes night air smell better", "The more powerful and original a mind, the more it will incline towards the religion of solitude", "If you learn to really sit with loneliness and embrace it for the gift that it is… an opportunity to get to know you", "The soul that sees beauty may sometimes walk alone"]
    }
    return mood_feedback
end

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