module UrlValidations
  extend ActiveSupport::Concern

  ALLOWED_SCHEMES = %w[http https].freeze

  included do
    validate :validate_long_url_format
  end

  private

    def validate_long_url_format
      return if long_url.blank?

      normalized_value = long_url.strip

      begin
        uri = URI.parse(normalized_value)
      rescue URI::InvalidURIError
        errors.add(:long_url, "is not a valid URL")
        return
      end

      unless uri.scheme.present? && (uri.host.present? || uri.scheme == "mailto")
        errors.add(:long_url, "must have a valid scheme and host")
        return
      end

      unless ALLOWED_SCHEMES.include?(uri.scheme.downcase)
        errors.add(:long_url, "must start with HTTP or HTTPS")
        return
      end

      normalized_host = uri.host.start_with?("www.") ? uri.host[4..-1] : uri.host
      unless normalized_host.include?(".")
        errors.add(:long_url, "is not a valid URL")
        return
      end

      normalized_url = uri.to_s.downcase
      unless normalized_url == normalized_value.downcase
        errors.add(:long_url, "is not a valid URL")
      end
    end
end
