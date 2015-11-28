require 'ostruct'
require 'spec_helper'

describe SearchKit::Subscribers do
  let(:bad_request)   { OpenStruct.new(status: 400, body: {}.to_json) }
  let(:not_found)     { OpenStruct.new(status: 404, body: {}.to_json) }
  let(:response)      { OpenStruct.new(body: response_body.to_json) }
  let(:unauthorized)  { OpenStruct.new(status: 401, body: {}.to_json) }
  let(:unprocessable) { OpenStruct.new(status: 422, body: {}.to_json) }

  let(:client)        { described_class.new }
  let(:response_body) { { data: [] } }
  let(:token)         { SearchKit.config.app_token }
  let(:email)         { "email@example.com" }
  let(:password)      { "password" }

  subject { client }

  it { is_expected.to respond_to :token }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#create' do
    let(:params) do
      {
        data: {
          type: 'subscribers',
          attributes: { email: email, password: password }
        }
      }
    end

    before { allow(client.connection).to receive(:post).and_return(response) }

    subject { client.create(email: email, password: password) }

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

  describe '#info' do
    before { allow(client.connection).to receive(:get).and_return(response) }

    subject { client.info }

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

    context 'when the token is unauthorized' do
      before do
        allow(client.connection).to receive(:get).and_return(unauthorized)
      end

      it "throws a not found error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unauthorized
      end
    end

    context 'when no subscriber is found' do
      before do
        allow(client.connection).to receive(:get).and_return(not_found)
      end

      it "throws a not found error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::SubscriberNotFound
      end
    end

  end

  describe '#update' do
    let(:params) do
      {
        token: token,
        data: {
          type: 'subscribers',
          attributes: { email: email, password: password }
        }
      }
    end

    before do
      allow(client.connection).to receive(:patch).and_return(response)
    end

    subject { client.update(email: email, password: password) }

    it "calls #connection.patch with given id and attributes" do
      expect(client.connection).to receive(:patch).with("/", params)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end

    context 'when the token is unauthorized' do
      before do
        allow(client.connection).to receive(:patch).and_return(unauthorized)
      end

      it "throws a not found error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unauthorized
      end
    end

    context 'when no subscriber is found' do
      before do
        allow(client.connection).to receive(:patch).and_return(not_found)
      end

      it "throws a not found error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::SubscriberNotFound
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
end
