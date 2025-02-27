# frozen_string_literal: true

class Url < ApplicationRecord
  include UrlValidations

  SHORT_CODE_LENGTH = 6

  before_validation :normalize_url
  before_validation :generate_unique_short_code, on: :create

  validates :long_url,
    presence: { message: "Long url cannot be blank" },
    format: {
      without: /\s/,
      message: "cannot contain spaces"
    }

  validates :short_code,
    presence: { message: "Short code cannot be blank" },
    uniqueness: {
      message: "has already been taken. Please try a different code"
    },
    length: { is: SHORT_CODE_LENGTH }

  def full_short_url(request)
    "#{request.base_url}/#{short_code}"
  end

  def to_response(request)
    {
      id: id,
      long_url: long_url,
      short_code: short_code,
      shortened_url: full_short_url(request),
      created_at: created_at
    }
  end

  private

    def normalize_url
      self.long_url = long_url.strip.downcase if long_url.present?
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
