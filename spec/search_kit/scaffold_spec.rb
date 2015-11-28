require 'ostruct'
require 'spec_helper'

describe SearchKit::Scaffold do
  let(:client)        { described_class.new }
  let(:json)          { response_body.to_json }
  let(:response_body) { { data: [] } }
  let(:response)      { OpenStruct.new(status: status, body: json) }
  let(:status)        { 200 }
  let(:token)         { SearchKit.config.app_token }

  before { allow(client.connection).to receive(:post).and_return(response) }

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

    subject { client.create(name, documents) }

    it "calls #connection.post with given name" do
      expect(client.connection).to receive(:post).with('', params)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when gven status 400' do
      let(:status) { 400 }

      it "throws a bad request error" do
        expect { subject }.to raise_exception SearchKit::Errors::BadRequest
      end
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it "throws an unprocessable error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unauthorized
      end
    end

    context 'when given status 422' do
      let(:status) { 422 }

      it "throws an unprocessable error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unprocessable
      end
    end

  end
end
