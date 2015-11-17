require 'spec_helper'

describe SearchKit::Events::CLI::Complete do
  let(:event_id) { 1 }
  let(:client)   { SearchKit::Events.new }
  let(:action)   { described_class.new(client, event_id) }

  before { allow(client).to receive(:complete) }

  subject { action }

  it { is_expected.to respond_to :client }
  it { is_expected.to respond_to :id }

  describe '#perform' do
    subject { action.perform }

    it "completes the event" do
      expect(client).to receive(:complete).with(event_id)
      subject
    end

    it "outputs acknowledgement of the completion" do
      expect(SearchKit.logger)
        .to receive(:info)
        .with(instance_of(String))
        .at_least(:once)

      subject
    end

    context 'when Faraday is unable to connect' do
      before do
        allow(client)
          .to receive(:complete)
          .and_raise(SearchKit::Errors::EventNotFound, "No event")
      end

      it "logs a warning" do
        expect(SearchKit.logger)
          .to receive(:warn)
          .with(instance_of(String))

        subject
      end
    end

    context 'when Faraday is unable to connect' do
      before do
        allow(client)
          .to receive(:complete)
          .and_raise(Faraday::ConnectionFailed, "A made up connection error")
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
          .to receive(:complete)
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
