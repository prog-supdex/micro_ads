require 'logger'

require_relative 'app/boot'

class App < Roda
  plugin :json
  plugin :typecast_params

  use Rack::CommonLogger, Logger.new($stdout)

  route do |r|
    r.on 'ads' do
      r.is do
        r.get(true) do
          pagy_object, records = PagyService.new(scope: Ad.order(Sequel.desc(:updated_at)), request: request).call

          if records.present?
            AdSerializer.new(records.all, links: PaginationLinks.pagination_links(pagy: pagy_object)).serialized_json
          else
            {}
          end
        end

        r.post do
          #TODO реализовать проверку параметров, по типу рельсовой params.requre(:ad).permit(...)
          params = JSON.parse(r.body.read)
          result = Ads::CreateService.call(ad: params['ad'])

          if result.success?
            response.status = Rack::Utils::SYMBOL_TO_STATUS_CODE[:created]

            AdSerializer.new(result.ad).serialized_json
          else
            error_response(result.ad, :unprocessable_entity)
          end
        end
      end
    end
  end
end
