# gems and dependencies
require "test/unit"
require_relative "../main"

# test within the login process
# test_nil: test if input in nil
# test_username: test if username is equal to input

class UserTest < Test::Unit::TestCase
    def test_nil
        username, password = login_details()
        line = find_user?(username)
        assert_not_nil(username)
    end
    def test_username
        username, password = login_details()
        line = find_user?(username)
        line == true
        assert_equal("user1", username)
    end
end