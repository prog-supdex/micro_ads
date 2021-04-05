class Roda
  module RodaPlugins
    module Auth
      class Unauthorized < StandardError; end

      AUTH_TOKEN = %r{\ABearer (?<token>.+)\z}

      module InstanceMethods
        def user_id
          user_id = auth_service.auth(matched_token).to_i

          raise Unauthorized if user_id.zero?

          user_id
        end

        private

        def auth_service
          @auth_service ||= AuthService::Client.fetch
        end

        def matched_token
          result = auth_header&.match(AUTH_TOKEN)
          return if result.blank?

          result[:token]
        end

        def auth_header
          request.env['HTTP_AUTHORIZATION']
        end
      end
    end

    register_plugin(:auth, Auth)
  end
end

