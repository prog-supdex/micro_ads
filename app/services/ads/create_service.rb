module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
      option :user_id
    end

    def call
      @ad = ::Ad.new(@ad.to_h)
      return fail!(@ad.errors) unless @ad.save

      GeocodingJob.perform_later(@ad.values)
    end
  end
end
