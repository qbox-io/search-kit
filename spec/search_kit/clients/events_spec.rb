require 'ostruct'
require 'spec_helper'

describe SearchKit::Clients::Events do
  let(:client)   { described_class.new }
  let(:id)       { 1 }
  let(:hash)     { {} }
  let(:json)     { hash.to_json }
  let(:response) { OpenStruct.new(status: status, body: json) }
  let(:status)   { 200 }
  let(:token)    { SearchKit.config.app_token }

  before do
    allow(client.connection).to receive(:delete).and_return(response)
    allow(client.connection).to receive(:get).and_return(response)
    allow(client.connection).to receive(:post).and_return(response)
    allow(JSON).to receive(:parse).and_return(hash)
  end

  subject { client }

  it { is_expected.to respond_to :token }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#complete' do
    subject { client.complete(id) }

    it { is_expected.to be_instance_of SearchKit::Models::Event }

    it "calls #connection.get with the base events path" do
      expect(client.connection).to receive(:delete).with(id, token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end

    context 'when given status 404' do
      let(:status) { 404 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::EventNotFound)
      end
    end
  end

  describe '#index' do
    subject { client.index }

    it { is_expected.to be_instance_of SearchKit::Models::Events }

    it "calls #connection.get with the base events path" do
      expect(client.connection).to receive(:get).with(token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end
  end

  describe '#pending' do
    let(:channel) { "colon:separated:string" }

    subject { client.pending(channel) }

    it { is_expected.to be_instance_of SearchKit::Models::Events }

    it "calls #connection.get with the base events path" do
      expect(client.connection)
        .to receive(:get)
        .with('', "filter[channel]" => channel, token: token)

      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end

  end

  describe '#publish' do
    let(:channel) { "colon:separated:string" }
    let(:options) { { channel: channel, payload: payload } }

    let(:payload) do
      { one_key: true, two_key: true, red_key: true, blue_key: true }
    end

    let(:params) do
      {
        token: token,
        data: {
          type: 'events',
          attributes: { channel: channel, payload: payload }
        }
      }
    end

    subject { client.publish(channel, payload) }

    it { is_expected.to be_instance_of SearchKit::Models::Event }

    it "calls #connection.get with the base events path" do
      expect(client.connection).to receive(:post).with('', params)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 400' do
      let(:status) { 400 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::BadRequest)
      end
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end

    context 'when given status 404' do
      let(:status) { 422 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::Unprocessable)
      end
    end
  end

  describe '#show' do
    subject { client.show(id) }

    it "calls #connection.get with the base events path / id" do
      expect(client.connection).to receive(:get).with(id, token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    context 'when given status 401' do
      let(:status) { 401 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::Unauthorized)
      end
    end

    context 'when given status 404' do
      let(:status) { 404 }

      it do
        expect { subject }.to raise_exception(SearchKit::Errors::EventNotFound)
      end
    end
  end

end
