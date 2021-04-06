require "csv"
require "tty-prompt"

prompt = TTY::Prompt.new
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