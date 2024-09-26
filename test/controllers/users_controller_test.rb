require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attributes = { email: 'admin1@gmail.com', password: 'admin1' }
  end

  test "should create user" do
    post users_url, params: { user: @attributes }

    json_response = JSON.parse(@response.body)

    assert json_response['email'] == @attributes[:email]
    assert_response :success
  end
end
