require 'spec_helper'

describe SearchKit::Events::Publish do
  let(:connection) { SearchKit::Events.new.connection }

  let(:options) do
    {
      connection: connection,
      channel:    "colon:separated:string",
      payload:    { key: "value" }
    }
  end

  let(:action) { described_class.new(options) }

  subject { action }

  it { is_expected.to respond_to :channel }
  it { is_expected.to respond_to :connection }
  it { is_expected.to respond_to :payload }

  describe '#perform' do

    subject { action.perform }

    context 'given a successful response' do
      let(:id) { 1 }

      let(:response) do
        {
          links: {
            self: "/api/events/#{id}",
            status: "/api/events/#{id}/status"
          }
        }
      end

      let(:successful_response) do
        OpenStruct.new(body: response.to_json, status: 202)
      end

      before do
        allow(connection)
          .to receive(:post)
          .and_return(successful_response)
      end

      it { is_expected.to eq response }

      it "parses the body" do
        expect(JSON)
          .to receive(:parse)
          .with(response.to_json, symbolize_names: true)
          .and_return(response)

        subject
      end

    end

    context 'otherwise' do
      let(:response) do
        { error: "An error message" }
      end

      let(:failure) { SearchKit::Errors::PublicationFailed }

      let(:failure_response) do
        OpenStruct.new(body: response.to_json, status: 400)
      end

      before do
        allow(connection)
          .to receive(:post)
          .and_return(failure_response)
      end

      it "raises a PublicationFailrue" do
        expect { subject }.to raise_exception(failure)
      end

    end
  end
end
