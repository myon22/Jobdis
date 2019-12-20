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
    assert_equal ["level5mikoto3510@gmail.com"], mail.from
    assert_match user.name,               mail.text_part.body.to_s.encode('UTF-8')
    assert_match user.activation_token,   mail.text_part.body.to_s.encode("UTF-8")
    assert_match CGI.escape(user.email),  mail.text_part.body.to_s.encode("UTF-8")
  end

  test "password_reset" do
    user = users(:ishizaki)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "PasswordReset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["level5mikoto3510@gmail.com"], mail.from
    assert_match user.name,               mail.text_part.body.to_s.encode('UTF-8')
    assert_match user.reset_token,   mail.text_part.body.to_s.encode("UTF-8")
    assert_match CGI.escape(user.email),  mail.text_part.body.to_s.encode("UTF-8")
  end

end
