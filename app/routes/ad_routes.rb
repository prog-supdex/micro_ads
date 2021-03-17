class AdRoutes < Application
  use Rack::CommonLogger, Logger.new($stdout)

  route do |r|
    r.on 'ads/v1' do
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
          params = JSON.parse(r.body.read)
          ad_params = r.validate_with!(validation: AdParamsContract, params: params)

          result = Ads::CreateService.call(ad: ad_params[:ad], user_id: params['user_id'])

          if result.success?
            response.status = :created

            AdSerializer.new(result.ad).serializable_hash
          else
            response.status = :unprocessable_entity
            error_response(result.ad)
          end
        end
      end
    end
  end
end
