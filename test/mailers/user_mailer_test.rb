require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "reset_password_email" do
    user = users(:one)
    user.save
    mail = UserMailer.reset_password_email(user)

    assert_equal "パスワードリセット", mail.subject
    assert_equal [ user.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "User One", mail.text_part.decoded
    assert_match edit_password_reset_url(user.reset_password_token), mail.text_part.decoded
  end
end
