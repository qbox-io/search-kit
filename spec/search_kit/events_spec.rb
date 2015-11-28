require 'ostruct'
require 'spec_helper'

describe SearchKit::Events do
  let(:token)  { SearchKit.config.app_token }
  let(:client) { described_class.new }

  subject { client }

  describe '#connection' do
    subject { client.connection }
    it { is_expected.to be_instance_of Faraday::Connection }
  end

  describe '#complete' do
    let(:id)            { 1 }
    let(:response_body) { "{}" }
    let(:response)      { OpenStruct.new(body: response_body) }

    subject { client.complete(id) }

    before do
      allow(client.connection).to receive(:delete).and_return(response)
    end

    it "calls #connection.get with the base events path" do
      expect(client.connection).to receive(:delete).with(id, token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body, symbolize_names: true)

      subject
    end
  end

  describe '#index' do
    let(:response_body) { { data: [] } }
    let(:response)      { OpenStruct.new(body: response_body.to_json) }

    subject { client.index }

    before { allow(client.connection).to receive(:get).and_return(response) }

    it "calls #connection.get with the base events path" do
      expect(client.connection).to receive(:get).with(token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end
  end

  describe '#pending' do
    let(:channel)       { "colon:separated:string" }
    let(:response_body) { { data: [] } }
    let(:response)      { OpenStruct.new(body: response_body.to_json) }

    before { allow(client.connection).to receive(:get).and_return(response) }

    subject { client.pending(channel) }

    it "calls #connection.get with the base events path" do
      expect(client.connection)
        .to receive(:get)
        .with('', "filter[channel]" => channel, token: token)

      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end
  end

  describe '#publish' do
    let(:channel) { "colon:separated:string" }

    let(:payload) do
      {
        one_key:  true,
        two_key:  true,
        red_key:  true,
        blue_key: true
      }
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

      expect(publish_double)
        .to receive(:perform)

      subject
    end
  end

  describe '#show' do
    let(:id)            { 1 }
    let(:response_body) { { data: [] } }
    let(:response)      { OpenStruct.new(body: response_body.to_json) }

    subject { client.show(id) }

    before do
      allow(client.connection).to receive(:get).and_return(response)
    end

    it "calls #connection.get with the base events path / id" do
      expect(client.connection).to receive(:get).with(id, token: token)
      subject
    end

    it "parses the json response" do
      expect(JSON)
        .to receive(:parse)
        .with(response_body.to_json, symbolize_names: true)

      subject
    end
  end

end
