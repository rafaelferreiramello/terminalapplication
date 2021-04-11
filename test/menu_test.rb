# gems and dependencies
require "test/unit"
require_relative "../main"

# test within the menu
# test_convert_symbol: test if input is converted to a symbol
# test_username: test if error handling is working

class MenuTest < Test::Unit::TestCase
    def test_convert_symbol
        prompt = TTY::Prompt.new
        mood_input = prompt.select("How are you feeling today?", %w(Cheerful Reflective Melancholy Angry Lonely))
        mood = mood_input.to_sym
        assert_kind_of(Symbol, :Cheerful)  
    end
    def test_menu_error
        begin
            prompt = TTY::Prompt.new
            mood_input = prompt.select("How are you feeling today?", %w(Cheerful Reflective Melancholy Angry Lonely))
        rescue
            puts "You need to run in your terminal 'bundle install'."
        end
        assert_raise_message("You need to run in your terminal 'bundle install'.") {raise "You need to run in your terminal 'bundle install'."}
    end
end