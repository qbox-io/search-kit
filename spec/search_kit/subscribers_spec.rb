require 'ostruct'
require 'spec_helper'

describe SearchKit::Subscribers do
  let(:client)        { described_class.new }
  let(:email)         { "email@example.com" }
  let(:json)          { response_body.to_json }
  let(:password)      { "password" }
  let(:response_body) { { data: [] } }
  let(:response)      { OpenStruct.new(status: status, body: json) }
  let(:status)        { 200 }
  let(:token)         { SearchKit.config.app_token }

  before do
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
    let(:params) do
      {
        data: {
          type: 'subscribers',
          attributes: { email: email, password: password }
        }
      }
    end

    subject { client.create(email: email, password: password) }

    it "calls #connection.post with given name" do
      expect(client.connection).to receive(:post).with('', params)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 400' do
      let(:status) { 400 }

      it "throws a bad request error" do
        expect { subject }.to raise_exception SearchKit::Errors::BadRequest
      end
    end

    context 'when given status 422' do
      let(:status) { 422 }

      it "throws an unprocessable error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unprocessable
      end
    end

  end

  describe '#info' do
    subject { client.info }

    it "calls #connection.get" do
      expect(client.connection).to receive(:get).with("", token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it "throws an unauthorized error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unauthorized
      end
    end

    context 'when given status 404' do
      let(:status) { 404 }

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

    subject { client.update(email: email, password: password) }

    it "calls #connection.patch with given id and attributes" do
      expect(client.connection).to receive(:patch).with("", params)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 400' do
      let(:status) { 400 }

      it "throws a bad request error" do
        expect { subject }.to raise_exception SearchKit::Errors::BadRequest
      end
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it "throws a not found error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unauthorized
      end
    end

    context 'when given status 404' do
      let(:status) { 404 }

      it "throws a not found error" do
        expect { subject }
          .to raise_exception SearchKit::Errors::SubscriberNotFound
      end
    end

    context 'when given status 422' do
      let(:status) { 422 }

      it "throws an Unprocessable error" do
        expect { subject }.to raise_exception SearchKit::Errors::Unprocessable
      end
    end

  end
end
