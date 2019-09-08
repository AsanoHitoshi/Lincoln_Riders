require 'test_helper'

class FollowRelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get follow_relationships_create_url
    assert_response :success
  end

  test "should get destroy" do
    get follow_relationships_destroy_url
    assert_response :success
  end

end
