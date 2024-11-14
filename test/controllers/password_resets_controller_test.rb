require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_password_reset_url
    assert_response :success
  end

  test "should get create" do
    post password_resets_url, params: { email: "one@example.com" }
    assert_response :redirect
  end

  test "should get edit" do
    user = users(:one)
    get edit_password_reset_url(user.id)
    assert_response :success
  end

  test "should get update" do
    user = users(:one)
    patch password_reset_url(user.id), params: { user: { password: "newpassword", password_confirmation: "newpassword" } }
    assert_response :redirect
  end
end
