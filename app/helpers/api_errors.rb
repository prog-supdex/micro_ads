class Roda
  module RodaPlugins
    module ApiErrors
      module InstanceMethods
        Roda.plugin(:error_handler) do |e|
          case e
          when Sequel::NoMatchingRow
            response.status = :not_found

            error_response I18n.t(:not_found, scope: 'api.errors')
          when Sequel::UniqueConstraintViolation
            response.status = :not_unique

            error_response I18n.t(:not_unique, scope: 'api.errors')
          when Roda::RodaPlugins::Validations::InvalidParams
            response.status = 422

            error_response I18n.t(:missing_parameters, scope: 'api.errors')
          when Sequel::NotNullConstraintViolation, KeyError
            response.status = :unprocessable_entity

            error_response I18n.t(:missing_parameters, scope: 'api.errors')
          when Roda::RodaPlugins::Auth::Unauthorized
            response.status = :unauthorized

            error_response I18n.t(:unauthorized, scope: 'api.errors')
          end
        end

        private

        def error_response(error_messages)
          case error_messages
          when Sequel::Model
            ErrorSerializer.from_model(error_messages)
          else
            ErrorSerializer.from_messages(error_messages)
          end
        end
      end
    end

    register_plugin :api_errors, ApiErrors
  end
end

