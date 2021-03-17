class Roda
  module RodaPlugins
    module Validations
      class InvalidParams < StandardError; end

      module RequestMethods

        def validate_with!(validation:, params:)
          result = validate_with(validation: validation, params: params)
          puts "failure? #{result.failure?}"
          raise InvalidParams if result.failure?

          puts 'here!!!'
          result
        end

        def validate_with(validation:, params:)
          puts 'checking params'
          contract = validation.new
          puts params.inspect
          result = contract.call(params)
          puts result.to_h.inspect

          result
        end
      end
    end

    register_plugin :validations, Validations
  end
end
