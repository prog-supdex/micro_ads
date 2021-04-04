module Ads
  class GeocodingJob < ApplicationJob
    queue_as :default

    def perform(ad_hash)
      coordinates = GeocoderService::Client.new.search(ad_hash[:city])

      return if coordinates.blank?

      ad_hash[:lat], ad_hash[:lon] = coordinates

      Ad.where(id: ad_hash[:id]).update(ad_hash)
    end
  end
end
