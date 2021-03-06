require 'ostruct'
require 'spec_helper'

describe SearchKit::Clients::Documents do
  let(:body)     { { data: [] } }
  let(:client)   { described_class.new }
  let(:id)       { 1 }
  let(:json)     { body.to_json }
  let(:response) { OpenStruct.new(body: json, status: status) }
  let(:slug)     { "index-slug" }
  let(:status)   { 200 }
  let(:token)    { SearchKit.config.app_token }

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

    let(:params) do
      { token: token, data: { type: "documents", attributes: document } }
    end

    subject { client.create(slug, document) }

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

      it "raises a not authorized error" do
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
    subject { client.delete(slug, id) }

    it "calls #connection.get with the base events path" do
      expect(client.connection)
        .to receive(:delete)
        .with("#{slug}/#{id}", token: token)

      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when the response status is 401' do
      let(:status) { 401 }

      it "raises a not authorized error" do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end

    context 'when the response status is 404' do
      let(:status) { 404 }

      it "raises an index not found error" do
        expect { subject }.to raise_exception(SearchKit::Errors::IndexNotFound)
      end
    end

  end

  describe '#show' do
    subject { client.show(slug, id) }

    it "calls #connection.get with the given id" do
      expect(client.connection)
        .to receive(:get)
        .with("#{slug}/#{id}", token: token)

      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when the response status is 401' do
      let(:status) { 401 }

      it "raises a not authorized error" do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end

    context 'when the response status is 404' do
      let(:status) { 404 }

      it "raises an index not found error" do
        expect { subject }.to raise_exception(SearchKit::Errors::IndexNotFound)
      end
    end

  end

  describe '#update' do
    let(:document) { { id: id, title: "The first document" } }

    let(:params) do
      {
        token: token,
        data: { type: "documents", id: id, attributes: document }
      }
    end

    subject { client.update(slug, id, document) }

    it "calls #connection.patch with the slug, id and document" do
      expect(client.connection)
        .to receive(:patch)
        .with("#{slug}/#{id}", params)

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

      it "raises a not authorized error" do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
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
