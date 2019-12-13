ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def logged_in_check
    !session[:user_id].nil?
  end

  def login_test(user)
    post login_path,params:{session:{email: user.email,
                                  password:"password"}}
  end

  class ActionDispatch::IntegrationTest

    def login_test(user,remember_me:"1",password:"password")
      post login_path,params:{ session: {email:user.email,
                                         password:password,
                                         remember_me:remember_me}}
    end
  end

end
