require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "reset_password_email" do
    user = users(:one)
    mail = UserMailer.reset_password_email(user)

    assert_equal "パスワードリセット", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
