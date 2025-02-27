# test/models/url_validation_test.rb
require "test_helper"

class UrlValidationTest < ActiveSupport::TestCase
  test "validates presence of long_url" do
    url = Url.new(long_url: "")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "cannot be blank"
  end

  test "validates long_url cannot contain spaces" do
    url = Url.new(long_url: "https://example.com/path with spaces")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "cannot contain spaces"
  end

  test "validates long_url must have HTTP or HTTPS scheme" do
    # URL with valid schemes
    valid_url1 = Url.new(long_url: "http://example.com")
    valid_url2 = Url.new(long_url: "https://example.com")
    assert valid_url1.valid?
    assert valid_url2.valid?

    # URL with valid schemes invalid schemes
    invalid_schemes = ["ftp://example.com", "ssh://example.com"]
    invalid_schemes.each do |scheme_url|
      url = Url.new(long_url: scheme_url)
      assert_not url.valid?, "Expected #{scheme_url} to be invalid"
      assert_includes url.errors[:long_url], "must start with HTTP or HTTPS"
    end
  end

  test "throws error for a non-URL string" do
    url = Url.new(long_url: "not a url")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "is not a valid URL"
  end

  test "throws error for URL missing host" do
    url = Url.new(long_url: "https://")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "must have a valid scheme and host"
  end

  test "throws error for URL missing scheme" do
    url = Url.new(long_url: "example.com")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "must have a valid scheme and host"
  end

  test "throws error for URL incomplete domain" do
    url = Url.new(long_url: "https://example")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "is not a valid URL"
  end

  test "throws error for URL with unsupported scheme" do
    url = Url.new(long_url: "ftp://example.com")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "must start with HTTP or HTTPS"
  end

  test "throws error for invalid URL" do
    url = Url.new(long_url: "https://example.com/^path")
    assert_not url.valid?
    assert_includes url.errors[:long_url], "is not a valid URL"
  end

  test "passes valid URL" do
    url = Url.new(long_url: "https://example.com/path?page=1&limit=10")
    assert url.valid?
  end

  test "normalizes URLs by trimming whitespace" do
    url = Url.new(long_url: "  https://example.com/path  ")
    url.valid?
    assert_equal "https://example.com/path", url.long_url
  end

  test "generates unique short code befor validation" do
    url = Url.new(long_url: "https://example.com")
    # Initially, short_code is nil.
    assert_nil url.short_code
    url.valid?
    assert_not_nil url.short_code
    assert_equal Url::SHORT_CODE_LENGTH, url.short_code.length
  end

  test "to_response method returns correct structure" do
    url = Url.create!(long_url: "https://example.com")
    request = ActionDispatch::TestRequest.create
    response = url.to_response(request)

    assert_equal url.id, response[:id]
    assert_equal url.long_url, response[:long_url]
    assert_equal url.short_code, response[:short_code]
    assert_equal url.full_short_url(request), response[:shortened_url]
    assert_equal url.created_at, response[:created_at]
  end

  test "full_short_url generates correct URL with base URL and short code" do
    url = Url.create!(long_url: "https://example.com")
    request = ActionDispatch::TestRequest.create
    expected_url = "#{request.base_url}/#{url.short_code}"
    assert_equal expected_url, url.full_short_url(request)
  end
end
