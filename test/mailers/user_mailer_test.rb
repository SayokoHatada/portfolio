require "test_helper"
include Rails.application.routes.url_helpers

class UserMailerTest < ActionMailer::TestCase
  test "reset_password_email" do
    user = users(:one)
    user.save
    mail = UserMailer.reset_password_email(user).deliver_now

    assert_equal "パスワードリセット", mail.subject
    assert_equal [ user.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "User One", mail.text_part.decoded
    assert_match edit_password_reset_url(user.reset_password_token, only_path: true), mail.text_part.decoded
  end
end
