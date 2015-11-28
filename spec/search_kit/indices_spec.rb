require 'ostruct'
require 'spec_helper'

describe SearchKit::Indices do
  let(:bad_request)   { OpenStruct.new(status: 400, body: {}.to_json) }
  let(:not_found)     { OpenStruct.new(status: 404, body: {}.to_json) }
  let(:response)      { OpenStruct.new(body: response_body.to_json) }
  let(:unprocessable) { OpenStruct.new(status: 422, body: {}.to_json) }

  let(:client)        { described_class.new }
  let(:response_body) { { data: [] } }
  let(:token)         { SearchKit.config.app_token }

  subject { client }

  it { is_expected.to respond_to :token }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#show' do
    let(:slug) { "slug" }

    subject { client.show(slug) }

    before { allow(client.connection).to receive(:get).and_return(response) }

    it "calls #connection.get with given slug" do
      expect(client.connection).to receive(:get).with(slug, token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when no index is found' do
      before do
        allow(client.connection).to receive(:get).and_return(not_found)
      end

      it "throws a NotFound error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::IndexNotFound
      end
    end

  end

  describe '#create' do
    let(:name) { "name" }
    let(:params) do
      {
        token: token,
        data: { type: 'indices', attributes: { name: name } }
      }
    end

    subject { client.create(name) }

    before { allow(client.connection).to receive(:post).and_return(response) }

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

      it "throws an Unprocessable error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::Unprocessable
      end
    end

    context 'when bad request' do
      before do
        allow(client.connection).to receive(:post).and_return(bad_request)
      end

      it "throws a Bad Request error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::BadRequest
      end
    end
  end

  describe '#update' do
    let(:name) { "name" }
    let(:new_name) { "New name" }
    let(:slug) { "name" }

    let(:params) do
      {
        token: token,
        data: { type: 'indices', attributes: { name: new_name } }
      }
    end

    subject { client.update(slug, name: new_name) }

    before do
      allow(client.connection).to receive(:patch).and_return(response)
    end

    it "calls #connection.patch with given slug and attributes" do
      expect(client.connection)
        .to receive(:patch)
        .with(slug, params)

      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when no index is found' do
      before do
        allow(client.connection).to receive(:patch).and_return(not_found)
      end

      it "throws a NotFound error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::IndexNotFound
      end

    end

    context 'when unprocessable' do
      before do
        allow(client.connection).to receive(:patch).and_return(unprocessable)
      end

      it "throws a NotFound error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::Unprocessable
      end
    end

    context 'when bad request' do
      before do
        allow(client.connection).to receive(:patch).and_return(bad_request)
      end

      it "throws a NotFound error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::BadRequest
      end
    end
  end

  describe '#delete' do
    let(:slug) { "slug" }

    subject { client.delete(slug) }

    before do
      allow(client.connection).to receive(:delete).and_return(response)
    end

    it "calls #connection.delete with given slug" do
      expect(client.connection)
        .to receive(:delete)
        .with(slug, token: token)

      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when no index is found' do
      before do
        allow(client.connection).to receive(:delete).and_return(not_found)
      end

      it "throws a NotFound error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::IndexNotFound
      end

    end
  end

end
