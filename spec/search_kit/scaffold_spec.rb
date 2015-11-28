require 'ostruct'
require 'spec_helper'

describe SearchKit::Scaffold do
  let(:bad_request)   { OpenStruct.new(status: 400, body: {}.to_json) }
  let(:response)      { OpenStruct.new(body: response_body.to_json) }
  let(:unauthorized)  { OpenStruct.new(status: 401, body: {}.to_json) }
  let(:unprocessable) { OpenStruct.new(status: 422, body: {}.to_json) }

  let(:client)        { described_class.new }
  let(:response_body) { { data: [] } }
  let(:token)         { SearchKit.config.app_token }

  subject { client }

  it { is_expected.to respond_to :token }

  describe '#create' do
    let(:name)      { "My Favorite Scaffolded Index" }
    let(:documents) { [{ its: "A", plain: "Hash", with: "An", id: 1 }] }

    let(:params) do
      {
        token: token,
        data: {
          type: 'indices',
          attributes: { name: name },
          relationships: { documents: documents }
        }
      }
    end

    before { allow(client.connection).to receive(:post).and_return(response) }

    subject { client.create(name, documents) }

    it "calls #connection.post with given name" do
      expect(client.connection).to receive(:post).with('/', params)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when unprocessable' do
      before do
        allow(client.connection).to receive(:post).and_return(unprocessable)
      end

      it "throws an unprocessable error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unprocessable
      end
    end

    context 'when bad request' do
      before do
        allow(client.connection).to receive(:post).and_return(bad_request)
      end

      it "throws a bad request error" do
        expect { subject }.to raise_exception SearchKit::Errors::BadRequest
      end
    end
  end
end
