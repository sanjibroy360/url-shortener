# frozen_string_literal: true

class Url < ApplicationRecord
  SHORT_CODE_LENGTH = 6
  ALLOWED_SCHEMES = %w[http https].freeze

  before_validation :normalize_url
  before_create :generate_unique_short_code

  validates :long_url,
    presence: { message: "URL cannot be blank" },
    format: {
      without: /\s/,
      message: "cannot contain spaces"
    }
  validate :validate_long_url

  validates :short_code,
    presence: { message: "Short code cannot be blank" },
    uniqueness: {
      message: "has already been taken. Please try a different code"
    },
    length: { is: SHORT_CODE_LENGTH }

  private

    def normalize_url
      self.long_url = long_url.strip if long_url.present?
    end

    def validate_long_url
      uri = URI.parse(long_url)
      unless ALLOWED_SCHEMES.include?(uri.scheme)
        errors.add(:long_url, "must start with HTTP or HTTPS")
      end
    rescue URI::InvalidURIError
      errors.add(:long_url, "is not a valid URL")
    end

    def generate_unique_short_code
      self.short_code = generate_short_code
    end

    def generate_short_code
      loop do
        short_code = SecureRandom.alphanumeric(SHORT_CODE_LENGTH)
        break short_code unless Url.exists?(short_code: short_code)
      end
    end
end
