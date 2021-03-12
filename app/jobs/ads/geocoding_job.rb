class Ads::GeocodingJob < ApplicationJob
  queue_as :default

  def perform(ad_hash)
    coordinates = Geocoder.search(ad_hash[:city])[0].coordinates

    return if coordinates.blank?

    ad_hash[:lat], ad_hash[:lon] = coordinates

    Ad.where(id: ad_hash[:id]).update(ad_hash)
  end
end
