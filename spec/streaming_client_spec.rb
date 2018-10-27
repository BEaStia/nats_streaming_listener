require 'spec_helper'

RSpec.describe NatsStreamingListener::StreamingClient do
  describe '.current' do
    context 'with mock' do
      let(:new_client) { NatsStreamingListener::StreamingClient.new }
      before { allow(NatsStreamingListener::StreamingClient).to receive(:current).and_return(new_client) }
      subject { described_class.current }

      it 'should return nats listener' do
        expect(described_class.current.class).to eq described_class
      end

      it 'should create client instance' do
        subject
        expect(NatsStreamingListener::StreamingClient).to have_received(:current)
      end
    end
  end

  describe '#establish_connection' do
    let(:service_name) { 'service_1' }
    let(:client) { described_class.new }

    subject { client.establish_connection(service_name: service_name) }

    context 'without errors' do
      before { allow_any_instance_of(::STAN::Client).to receive(:connect).and_return(true) }

      it 'should set service name' do
        expect { subject }.to change { client.service_name }.from(nil)
      end

      it 'should return true' do
        expect(subject).to be_truthy
      end
    end

    context 'with received error' do
      before do
        allow_any_instance_of(::STAN::Client).to receive(:connect).and_raise(StandardError.new)
        allow(client).to receive(:log).and_return(true)
      end

      it 'should raise error' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#subscribe' do
    let(:service_name) { 'service_1' }
    let(:client) do
      client = described_class.new
      client.establish_connection(
        client_id: 'client_id',
        cluster_name: 'cluster_name',
        service_name: 'client_id',
        nats: { servers: ['nats://127.0.0.1:4223']}
      )
      client
    end
    let(:topic) { 'topic' }

    subject do
      client.subscribe(topic, {start_at: :last_received}) { |_m, _r, _s| }
    end

    it 'should not fail' do
      expect { subject }.not_to raise_exception
    end

    context 'with mock' do
      before do
        allow_any_instance_of(::STAN::Client).to receive(:connect).and_return(true)
        allow_any_instance_of(::STAN::Client).to receive(:subscribe).and_return(true)
      end

      it 'should subscribe' do
        expect(subject).to be_truthy
      end
    end
  end

  describe '#request' do
    let(:service_name) { 'service_1' }
    let(:client) do
      client = described_class.new
      client.establish_connection(
        client_id: 'client_id',
        cluster_name: 'cluster_name',
        service_name: 'client_id',
        nats: { servers: ['nats://127.0.0.1:4223']}
      )
      client
    end
    let(:topic) { 'topic' }

    before do
      allow_any_instance_of(::STAN::Client).to receive(:connect).and_return(true)
      allow_any_instance_of(::STAN::Client).to receive(:request).and_return(true)
    end
    subject { client.request(topic, 'Hi, there!', {}) }

    it 'should call #with_connection' do
      expect { subject }.not_to raise_exception
    end
  end
end
