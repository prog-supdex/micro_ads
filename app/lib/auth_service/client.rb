require 'securerandom'
require 'dry/initializer'
require_relative 'api'

module AuthService
  class Client
    extend Dry::Initializer[undefined: false]
    include Api

    attr_reader :response, :correlation_id

    option :reply_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    def self.fetch
      Thread.current['auth_service.rpc_client'] ||= new.start
    end

    def start
      reply_queue.subscribe do |_, properties, payload|
        if properties[:correlation_id] == correlation_id

          @response = payload

          lock.synchronize { condition.signal }
        end
      end

      self
    end

    private

    def publish(token, opts = {})
      @correlation_id = SecureRandom.uuid

      RabbitMq.exchange.publish(
        token,
        opts.merge!(
          routing_key: 'authentication',
          correlation_id: correlation_id,
          reply_to: reply_queue.name
        )
      )

      lock.synchronize { condition.wait(lock) }

      response
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('', exclusive: true)
    end
  end
end
