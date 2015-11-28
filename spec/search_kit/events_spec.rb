require 'ostruct'
require 'spec_helper'

describe SearchKit::Events do
  let(:client)   { described_class.new }
  let(:id)       { 1 }
  let(:json)     { "{}" }
  let(:response) { OpenStruct.new(status: status, body: json) }
  let(:status)   { 200 }
  let(:token)    { SearchKit.config.app_token }

  before do
    allow(client.connection).to receive(:delete).and_return(response)
    allow(client.connection).to receive(:get).and_return(response)
  end

  subject { client }

  it { is_expected.to respond_to :token }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#complete' do
    subject { client.complete(id) }

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

    let(:payload) do
      { one_key: true, two_key: true, red_key: true, blue_key: true }
    end

    let(:options) do
      {
        connection: client.connection,
        channel:    channel,
        payload:    payload
      }
    end

    let(:publish_double) { double(perform: true) }

    subject { client.publish(channel, payload) }

    it "initializes a SearchKit::Events::Publish action object" do
      expect(SearchKit::Events::Publish)
        .to receive(:new)
        .with(options)
        .and_return(publish_double)

      subject
    end

    it "calls perform on the returned action" do
      allow(SearchKit::Events::Publish)
        .to receive(:new)
        .with(options)
        .and_return(publish_double)

      expect(publish_double).to receive(:perform)

      subject
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
