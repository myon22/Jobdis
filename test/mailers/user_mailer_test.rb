require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup 
    @user = users(:ishizaki)
  end

  test "account_activation" do
    user = users(:ishizaki)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "AccountActivation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match user.name,               mail.text_part.body.to_s.encode('UTF-8')
    assert_match user.activation_token,   mail.text_part.body.to_s.encode("UTF-8")
    assert_match CGI.escape(user.email),  mail.text_part.body.to_s.encode("UTF-8")
  end

  #test "password_reset" do
  #  mail = UserMailer.password_reset
  #  assert_equal "Password reset", mail.subject
  #  assert_equal ["to@example.org"], mail.to
  #  assert_equal ["from@example.com"], mail.from
  #  assert_match "Hi", mail.body.encoded
  #end

end