require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    Url.delete_all
    @url = Url.create(long_url: "https://example.com/some/path")
    @invalid_short_code = "nonexistent"
  end

  # INDEX ACTION TESTS
  test "should get index" do
    get urls_path, as: :json
    assert_response :success

    response_data = JSON.parse(response.body)
    assert_equal "Successfully fetched all URLs", response_data["notice"]
    assert_not_nil response_data["urls"]
  end

  # CREATE ACTION TESTS
  test "should create url with valid attributes" do
    assert_difference("Url.count") do
      post urls_path, params: { url: { long_url: "https://example.org" } }, as: :json
    end

    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal "Successfuly created shortend URL", response_data["notice"]
  end

  test "should not create url with invalid URL format" do
    assert_no_difference("Url.count") do
      post urls_path, params: { url: { long_url: "not-a-url" } }, as: :json
    end

    assert_response 422
  end

  # REDIRECT ACTION TESTS
  test "should redirect to long URL when valid short code is provided" do
    get "/#{@url.short_code}"

    assert_response :moved_permanently
    assert_redirected_to @url.long_url
  end

  test "should return not found when invalid short code is provided for redirect" do
    get "/#{@invalid_short_code}", as: :json

    assert_response :not_found
    response_data = JSON.parse(response.body)
    assert_equal "Shortened URL not found", response_data["error"]
  end

  # DESTROY ACTION TESTS
  test "should destroy url when valid short code is provided" do
    url_to_delete = Url.create!(long_url: "https://example.com/to-delete")

    assert_difference("Url.count", -1) do
      delete "/urls/#{url_to_delete.short_code}", as: :json
    end

    assert_response :success
    response_data = JSON.parse(response.body)
    assert_equal "Shortened URL deleted successfully", response_data["notice"]
  end

  test "should return not found when invalid short code is provided for destroy" do
    assert_no_difference("Url.count") do
      delete "/#{@invalid_short_code}", as: :json
    end

    assert_response :not_found
    response_data = JSON.parse(response.body)
    assert_equal "Not Found", response_data["error"]
  end
end
