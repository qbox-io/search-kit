require 'spec_helper'

describe SearchKit::Events::CLI::Publish do
  let(:options) { { 'payload' => { stuff: true } } }
  let(:channel) { 'mail' }
  let(:client)  { SearchKit::Events.new }
  let(:action)  { described_class.new(client, channel, options) }

  subject { action }

  it { is_expected.to respond_to :channel }
  it { is_expected.to respond_to :client }
  it { is_expected.to respond_to :payload }

  describe '#perform' do
    before do
      allow(client)
        .to receive(:publish)
        .and_return(data: { links: { self: "/a/status/uri" } })
    end

    subject { action.perform }

    it "publishes an event" do
      expect(client)
        .to receive(:publish)
        .with(action.channel, action.payload)

      subject
    end

    context 'when Faraday is unable to connect' do
      before do
        allow(client)
          .to receive(:publish)
          .and_raise(Faraday::ConnectionFailed, "A made up connection error")
      end

      it "logs a warning" do
        expect(SearchKit.logger)
          .to receive(:warn)
          .with(instance_of(String))

        subject
      end
    end

    context "when the publication fails" do
      before do
        allow(client)
          .to receive(:publish)
          .and_raise(SearchKit::Errors::PublicationFailed, "yep")
      end

      it "logs a warning" do
        expect(SearchKit.logger)
          .to receive(:warn)
          .with(instance_of(String))

        subject
      end
    end

    context "when given a JSON error" do
      before do
        allow(client)
          .to receive(:publish)
          .and_raise(JSON::ParserError, "Explosivo")
      end

      it "logs a detailed warning" do
        expect(SearchKit.logger)
          .to receive(:warn)
          .with(instance_of(String))
          .at_least(:once)

        subject
      end
    end
  end

end
