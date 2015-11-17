require 'ostruct'
require 'spec_helper'

describe SearchKit::Search do
  let(:status)        { 200 }
  let(:client)        { described_class.new }
  let(:json)          { response_body.to_json }
  let(:response_body) { { data: [] } }
  let(:response)      { OpenStruct.new(body: json, status: status) }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#search' do
    let(:slug)    { "an-index-slug" }
    let(:phrase)  { "red boots" }
    let(:options) { { phrase: phrase, filters: filters } }
    let(:filters) { { size: 10.5, width: "Wide", gender: "Mens" } }

    subject { client.search(slug, options) }

    before do
      allow(client.connection).to receive(:post).and_return(response)
    end

    it "calls #connection.get with the base events path" do
      expect(client.connection)
        .to receive(:post)
        .with(slug, data: { type: 'searches', attributes: options })

      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when the response status is 400' do
      let(:status) { 400 }

      it "raises a bad request error" do
        expect { subject }.to raise_exception(SearchKit::Errors::BadRequest)
      end
    end

    context 'when the response status is 422' do
      let(:status) { 422 }

      it "raises an unprocessable error" do
        expect { subject }.to raise_exception(SearchKit::Errors::Unprocessable)
      end
    end

    context 'when the response status is 404' do
      let(:status) { 404 }

      it "raises an index not found error" do
        expect { subject }.to raise_exception(SearchKit::Errors::IndexNotFound)
      end
    end

  end

end