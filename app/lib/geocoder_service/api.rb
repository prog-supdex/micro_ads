module GeocoderService
  module Api
    def search(address)
      response = connection.post('search', address: address)

      response.body if response.success?
    end
  end
end
