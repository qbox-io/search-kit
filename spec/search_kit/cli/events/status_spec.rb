require 'spec_helper'

describe SearchKit::CLI::Events::Status do
  let(:event_id) { 345 }
  let(:client_response) do
    {
      data: {
        type: 'events',
        id: event_id,
        attributes: {
          channel: 'mail',
          payload: { id: event_id, title: "Gee willikers" }
        }
      }
    }
  end

  let(:client) { SearchKit::Clients::Events.new }
  let(:action) { described_class.new(client, event_id) }

  before { allow(client).to receive(:show).and_return(client_response) }

  subject { action }

  it { is_expected.to respond_to :client }
  it { is_expected.to respond_to :id }

  describe '#perform' do
    subject { action.perform }

    it "displays the event" do
      expect(client).to receive(:show).with(event_id)
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
          .to receive(:show)
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
          .to receive(:show)
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
          .to receive(:show)
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
