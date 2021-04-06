require "csv"
require "tty-prompt"

posts = []

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

prompt = TTY::Prompt.new
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
  
