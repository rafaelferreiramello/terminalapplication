require "csv"
require "tty-prompt"

moods = CSV.open("moods.csv", "a")
mood_feedback =  {
    Cheerful: ["Life is 10% what happens to me and 90% of how I react to it", "Go the extra mile. It’s never crowded there", "Believe you can and you’re halfway there", "Keep your face always toward the sunshine – and shadows will fall behind you", "Make each day your masterpiece"],
    Reflective: ["If you want to lift yourself up, lift up someone else", "You get in life what you have the courage to ask for", "We can’t help everyone, but everyone can help someone", "You must be the change you wish to see in this world", "None of us is as smart as all of us"],
    Melancholy: ["I can’t change the direction of the wind, but I can adjust my sails to always reach my destination", "Begin anywhere", "Whenever you find yourself doubting how far you can go, just remember how far you have come", "Do not wait; the time will never be just right", "Start where you are. Use what you have. Do what you can"],
    Angry: ["Nothing ever gets easier. You just get stronger", "I will allow life’s changes to make me better, not bitter", "Nobody can hurt me without my permission", "The best revenge is massive success", "The question isn’t who is going to let me; it’s who is going to stop me"],
    Lonely: ["The strongest men are the most alone", "Loneliness adds beauty to life. It puts a special burn on sunsets and makes night air smell better", "The more powerful and original a mind, the more it will incline towards the religion of solitude", "If you learn to really sit with loneliness and embrace it for the gift that it is… an opportunity to get to know you", "The soul that sees beauty may sometimes walk alone"]
}


prompt = TTY::Prompt.new
mood_input = prompt.select("how are you feeling today?", %w(Cheerful Reflective Melancholy Angry Lonely))
mood = mood_input
    if mood == "Cheerful"
        puts mood_feedback[:Cheerful].sample
        CSV.open("moods.csv", "a") do |csv|
            csv << [mood]
        end
    elsif mood == "Reflective"
        puts mood_feedback[:Reflective].sample
        CSV.open("moods.csv", "a") do |csv|
            csv << [mood]
        end
    elsif mood == "Melancholy"
        puts mood_feedback[:Melancholy].sample
        CSV.open("moods.csv", "a") do |csv|
            csv << [mood]
        end
    elsif mood == "Angry"
        puts mood_feedback[:Angry].sample
        CSV.open("moods.csv", "a") do |csv|
            csv << [mood]
        end
    elsif mood == "Lonely"
        puts mood_feedback[:Lonely].sample
        CSV.open("moods.csv", "a") do |csv|
            csv << [mood]
        end
    end
