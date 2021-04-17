module Ads
  class UpdateService
    prepend BasicService

    option :id
    option :data
    option :ad, default: proc { Ad.first(id: @id) }

    def call
      return fail!(I18n.t(:not_found, scope: 'services.ads.update_service')) if @ad.blank?

      if @ad.update_fields(@data, %i[lat lon])
        Application.logger.info(
          'updated coordinates(lat, lon)',
          city: payload['city'],
          coordinates: { lat: @data[:lat], lon: @data[:lon] }
        )
      end
    end
  end
end
