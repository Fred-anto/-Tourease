# frozen_string_literal: true
require "net/http"
require "json"
require "uri"

class RoyaltyFreeImageFinder
  ENDPOINT = "https://pixabay.com/api/"

  def self.for_destination(query)
    return nil if query.blank?
    key = ENV["PIXABAY_API_KEY"]
    return nil if key.blank?

    Rails.cache.fetch("pixabay:#{query.parameterize}", expires_in: 7.days) do
      uri = URI(ENDPOINT)
      uri.query = URI.encode_www_form(
        key: key,
        q: query,
        image_type: "photo",
        orientation: "horizontal",
        safesearch: "true",
        per_page: 10
      )

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, read_timeout: 4) do |http|
        http.request(Net::HTTP::Get.new(uri))
      end
      return nil unless res.is_a?(Net::HTTPSuccess)

      hits = JSON.parse(res.body)["hits"] || []
      hit  = hits.max_by { |h| h["likes"].to_i } || hits.first
      hit && (hit["largeImageURL"] || hit["webformatURL"])
    end
  rescue => e
    Rails.logger.warn("[Pixabay] #{e.class}: #{e.message}")
    nil
  end
end
