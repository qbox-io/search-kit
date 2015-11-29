require 'ostruct'
require 'spec_helper'

describe SearchKit::Clients::Populate do
  let(:response)      { OpenStruct.new(status: status, body: json) }
  let(:json)          { response_body.to_json }
  let(:status)        { 200 }
  let(:client)        { described_class.new }
  let(:id)            { 1 }
  let(:response_body) { { data: [] } }
  let(:slug)          { "an-index-slug" }
  let(:token)         { SearchKit.config.app_token }

  before do
    allow(client.connection).to receive(:delete).and_return(response)
    allow(client.connection).to receive(:get).and_return(response)
    allow(client.connection).to receive(:patch).and_return(response)
    allow(client.connection).to receive(:post).and_return(response)
  end

  subject { client }

  it { is_expected.to respond_to :token }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#create' do
    let(:document) { { id: id, title: "The first document" } }
    let(:documents) { [document] }

    let(:params) do
      {
        token: token,
        data: [{ type: "documents", attributes: document }]
      }
    end

    subject { client.create(slug, documents) }

    it "calls #connection.post with the base path and a document" do
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

      it "raises an index not found error" do
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

  describe '#update' do
    let(:document)  { { id: id, title: "The first document" } }
    let(:documents) { [document] }

    let(:params) do
      {
        token: token,
        data: [{ type: "documents", id: id, attributes: document }]
      }
    end

    subject { client.update(slug, documents) }

    it "calls #connection.patch with the slug and documents" do
      expect(client.connection).to receive(:patch).with(slug, params)
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

      it "raises an index not found error" do
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

  describe '#delete' do
    let(:params) do
      {
        token: token,
        data: [{ type: 'documents', id: id, attributes: { id: id } }]
      }
    end

    subject { client.delete(slug, [id]) }

    it "calls #connection.get with the correct params" do
      expect(client.connection).to receive(:delete).with(slug, params)
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

      it "raises an index not found error" do
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
