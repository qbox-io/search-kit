require 'ostruct'
require 'spec_helper'

describe SearchKit::Clients::Search do
  let(:client)        { described_class.new }
  let(:json)          { response_body.to_json }
  let(:response_body) { { data: {} } }
  let(:response)      { OpenStruct.new(body: json, status: status) }
  let(:status)        { 200 }
  let(:token)         { SearchKit.config.app_token }

  before do
    allow(client.connection).to receive(:post).and_return(response)
    allow(JSON).to receive(:parse).and_return(response_body)
  end

  subject { client }

  it { is_expected.to respond_to :token }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#search' do
    let(:filters) { { size: 10.5, width: "Wide", gender: "Mens" } }
    let(:options) { { phrase: phrase, filters: filters } }
    let(:phrase)  { "red boots" }
    let(:slug)    { "an-index-slug" }

    let(:params) do
      {
        token: token,
        data: { type: 'searches', attributes: options }
      }
    end

    subject { client.search(slug, options) }

    it { is_expected.to be_instance_of SearchKit::Models::Search }

    it "calls #connection.get with the base events path" do
      expect(client.connection).to receive(:post).with(slug, params)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)

      subject
    end

    context 'when the response status is 400' do
      let(:status) { 400 }

      it "raises a bad request error" do
        expect { subject }.to raise_exception(SearchKit::Errors::BadRequest)
      end
    end

    context 'when the response status is 401' do
      let(:status) { 401 }

      it "raises an unauthorized error" do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end

    context 'when the response status is 404' do
      let(:status) { 404 }

      it "raises an index not found error" do
        expect { subject }.to raise_exception(SearchKit::Errors::IndexNotFound)
      end
    end

    context 'when the response status is 422' do
      let(:status) { 422 }

      it "raises an unprocessable error" do
        expect { subject }.to raise_exception(SearchKit::Errors::Unprocessable)
      end
    end

  end
end
