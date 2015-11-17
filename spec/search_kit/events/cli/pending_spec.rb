require 'spec_helper'

describe SearchKit::Events::CLI::Pending do
  let(:channel) { 'mail' }
  let(:client) { SearchKit::Events.new }
  let(:action) { described_class.new(client, channel) }

  subject { action }

  it { is_expected.to respond_to :channel }
  it { is_expected.to respond_to :client }

  describe '#perform' do
    let(:client_response) do
      { data: [] }
    end

    before { allow(client).to receive(:pending).and_return(client_response) }

    subject { action.perform }

    it "retrieves pending events" do
      expect(client)
        .to receive(:pending)
        .with(action.channel)

      subject
    end

    context "when there are events" do
      let(:client_response) do
        {
          data: [{
            type: 'events',
            id: 345,
            attributes: {
              channel: channel,
              payload: { id: 345, title: "Gee willikers" }
            }
          }]
        }
      end

      it "outputs log header and event detail" do
        expect(SearchKit.logger)
          .to receive(:info)
          .with(instance_of(String))
          .at_least(:twice)

        subject
      end
    end

    context 'when there are no events' do
      it "outputs that no events are found" do
        expect(SearchKit.logger)
          .to receive(:info)
          .with(instance_of(String))
          .at_least(:once)

        subject
      end
    end

    context 'when Faraday is unable to connect' do
      before do
        allow(client)
          .to receive(:pending)
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
          .to receive(:pending)
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
