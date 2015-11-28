require 'ostruct'
require 'spec_helper'

describe SearchKit::Keys do
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

  describe '#create' do
    let(:name) { "name" }

    let(:params) do
      {
        token: token,
        data: { type: 'keys', attributes: { name: name } }
      }
    end

    before { allow(client.connection).to receive(:post).and_return(response) }

    subject { client.create(name) }

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

  describe '#index' do
    before { allow(client.connection).to receive(:get).and_return(response) }

    subject { client.index }

    it "calls #connection.get" do
      expect(client.connection).to receive(:get).with("/", token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end
  end


  describe '#show' do
    let(:id) { 1 }

    before { allow(client.connection).to receive(:get).and_return(response) }

    subject { client.show(id) }

    it "calls #connection.get with given id" do
      expect(client.connection).to receive(:get).with(id, token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when no key is found' do
      before do
        allow(client.connection).to receive(:get).and_return(not_found)
      end

      it "throws a NotFound error" do
        expect { subject }.to raise_exception SearchKit::Errors::KeyNotFound
      end

    end
  end

  describe '#update' do
    let(:name)     { "name" }
    let(:new_name) { "New name" }
    let(:id)       { 1 }

    let(:params) do
      {
        token: token,
        data: { type: 'keys', attributes: { name: new_name } }
      }
    end

    before do
      allow(client.connection).to receive(:patch).and_return(response)
    end

    subject { client.update(id, name: new_name) }

    it "calls #connection.patch with given id and attributes" do
      expect(client.connection).to receive(:patch).with(id, params)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when no key is found' do
      before do
        allow(client.connection).to receive(:patch).and_return(not_found)
      end

      it "throws a NotFound error" do
        expect { subject }.to raise_exception SearchKit::Errors::KeyNotFound
      end

    end

    context 'when unprocessable' do
      before do
        allow(client.connection).to receive(:patch).and_return(unprocessable)
      end

      it "throws an Unprocessable error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unprocessable
      end
    end

    context 'when bad request' do
      before do
        allow(client.connection).to receive(:patch).and_return(bad_request)
      end

      it "throws a bad request error" do
        expect { subject }.to raise_exception SearchKit::Errors::BadRequest
      end
    end
  end

  describe '#expire' do
    let(:id) { 1 }

    before do
      allow(client.connection).to receive(:delete).and_return(response)
    end

    subject { client.expire(id) }

    it "calls #connection.delete with given slug" do
      expect(client.connection).to receive(:delete).with(id, token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when no key is found' do
      before do
        allow(client.connection).to receive(:delete).and_return(not_found)
      end

      it "throws a NotFound error" do
        expect { subject }.to raise_exception SearchKit::Errors::KeyNotFound
      end

    end
  end

end
