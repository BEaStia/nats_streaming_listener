require 'spec_helper'

RSpec.describe NatsStreamingListener::StreamingSubscriber do
  describe '.client' do
    context 'with mock' do
      let(:new_client) { NatsStreamingListener::StreamingClient.new }
      before { allow(NatsStreamingListener::StreamingClient).to receive(:current).and_return(new_client) }
      subject { described_class.client }

      it 'should return nats listener' do
        expect(described_class.client.class).to eq NatsStreamingListener::StreamingClient
      end

      it 'should create client instance' do
        subject
        expect(NatsStreamingListener::StreamingClient).to have_received(:current)
      end

      it 'should return client' do
        expect(subject).to eq new_client
      end
    end
  end
end
