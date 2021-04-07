require "csv"
require "tty-prompt"

charts = {}

prompt = TTY::Prompt.new
chart_input = prompt.select("What would you like to check?", %w(Week Month))
chart = chart_input
    case chart
    when "Week"
        CSV.open("moods.csv", "r") do |csv|
            csv.each do |mood|
                next if mood == " "
                charts[mood] = 0 unless charts.include?(mood)
                charts[mood] += 1
            end
            puts charts
        end
    when "Month" 
        puts "month"
    end