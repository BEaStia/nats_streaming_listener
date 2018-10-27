# frozen_string_literal: true

require 'nats_listener_core'

module NatsStreamingListener
  # Base subscriber using nats-streaming
  class StreamingSubscriber <  NatsListenerCore::AbstractSubscriber
    class << self
      def client
        NatsStreamingListener::StreamingClient.current
      end
    end
  end
end
