require "csv"
require "tty-prompt"

charts = {}

prompt = TTY::Prompt.new
chart_input = prompt.select("What would you like to check?", %w(Top1 Top3))
chart = chart_input
    case chart
    when "Top1"
        CSV.open("moods.csv", "r") do |csv|
            csv.each do |mood|
                charts[mood] = 0 unless charts.include?(mood)
                charts[mood] += 1
            end
            new_chart = []
            new_chart = charts.sort_by {|k,v| v}.reverse
            puts "Your most frequently mood is #{new_chart[0][0][0]} and you told us that you were feeling like this #{new_chart[0][1]} times"
        end
    when "Top3" 
        CSV.open("moods.csv", "r") do |csv|
            csv.each do |mood|
                charts[mood] = 0 unless charts.include?(mood)
                charts[mood] += 1
            end
            new_chart = []
            new_chart = charts.sort_by {|k,v| v}.reverse
            puts "Your most frequently mood is #{new_chart[0][0][0]} and you told us that you were feeling like this #{new_chart[0][1]} times"
            puts "Your second most frequently mood is #{new_chart[1][0][0]} and you told us that you were feeling like this #{new_chart[1][1]} times"
            puts "Your third most frequently mood is #{new_chart[2][0][0]} and you told us that you were feeling like this #{new_chart[2][1]} times"
        end
    end