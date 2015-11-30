require 'spec_helper'

describe SearchKit::CLI::Events do
  let(:channel)  { "colon:separated:values" }
  let(:cli)      { described_class.new }
  let(:json)     { response.to_json }
  let(:response) { {} }
  let(:event)    { SearchKit::Models::Event.new }
  let(:events)   { SearchKit::Models::Events.new }
  let(:slug)     { "an-index-slug" }

  subject { cli }

  describe '#complete' do
    let(:id) { 1 }

    before { allow(cli.client).to receive(:complete).and_return(event) }

    subject { cli.complete(id) }

    it "calls client.complete with the event id" do
      expect(cli.client).to receive(:complete).with(id)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:complete).and_raise(*error) }

      context 'not found error' do
        let(:error) { SearchKit::Errors::EventNotFound }

        it do
          expect(cli.messages).to receive(:not_found)
          subject
        end
      end

      context 'not found error' do
        let(:error) { [Faraday::ConnectionFailed, "Message"] }

        it do
          expect(cli.messages).to receive(:no_service)
          subject
        end
      end
    end
  end

  describe '#pending' do
    before do
      allow(cli.client).to receive(:index).and_return(events)
      allow(cli.client).to receive(:pending).and_return(events)
    end

    subject { cli.pending(channel) }

    context 'when given a channel' do
      it "calls client.pending with the channel" do
        expect(cli.client).to receive(:pending).with(channel)
        subject
      end
    end

    context 'otherwise' do
      let(:channel) { nil }

      it "calls client.index" do
        expect(cli.client).to receive(:index)
        subject
      end
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    context 'error handling' do
      before do
        allow(cli.client).to receive(:index).and_raise(*error)
        allow(cli.client).to receive(:pending).and_raise(*error)
      end

      context 'not found error' do
        let(:error) { SearchKit::Errors::Unauthorized }

        it do
          expect(cli.messages).to receive(:unauthorized)
          subject
        end
      end

      context 'bad request error' do
        let(:error) { SearchKit::Errors::BadRequest }

        it do
          expect(cli.messages).to receive(:bad_request)
          subject
        end
      end

      context 'unprocessable error' do
        let(:error) { SearchKit::Errors::Unprocessable }

        it do
          expect(cli.messages).to receive(:unprocessable)
          subject
        end
      end

      context 'not found error' do
        let(:error) { [Faraday::ConnectionFailed, "Message"] }

        it do
          expect(cli.messages).to receive(:no_service)
          subject
        end
      end

    end
  end

  describe '#publish' do
    let(:payload)      { { one_fish: true, two_fish: true } }
    let(:payload_json) { payload.to_json }

    before do
      allow(cli.client).to receive(:publish).and_return(event)
    end

    subject { cli.publish(channel, payload_json) }

    it "parses the given document json" do
      expect(JSON).to receive(:parse).with(payload_json, symbolize_names: true)
      subject
    end

    it "calls client.create with the slug and document" do
      expect(cli.client).to receive(:publish).with(channel, payload)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    context 'when given bad json' do
      let(:payload) { "Arglebargle" }

      it "reports an error" do
        expect(cli.messages).to receive(:json_parse_error)
        subject
      end
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:publish).and_raise(*error) }

      context 'not found error' do
        let(:error) { SearchKit::Errors::Unauthorized }

        it do
          expect(cli.messages).to receive(:unauthorized)
          subject
        end
      end

      context 'bad request error' do
        let(:error) { SearchKit::Errors::BadRequest }

        it do
          expect(cli.messages).to receive(:bad_request)
          subject
        end
      end

      context 'unprocessable error' do
        let(:error) { SearchKit::Errors::Unprocessable }

        it do
          expect(cli.messages).to receive(:unprocessable)
          subject
        end
      end

      context 'not found error' do
        let(:error) { [Faraday::ConnectionFailed, "Message"] }

        it do
          expect(cli.messages).to receive(:no_service)
          subject
        end
      end

    end
  end

  describe '#status' do
    let(:id) { 1 }

    before { allow(cli.client).to receive(:show).and_return(event) }

    subject { cli.status(id) }

    it "calls client.show with the event id" do
      expect(cli.client).to receive(:show).with(id)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:show).and_raise(*error) }

      context 'not found error' do
        let(:error) { SearchKit::Errors::EventNotFound }

        it do
          expect(cli.messages).to receive(:not_found)
          subject
        end
      end

      context 'not found error' do
        let(:error) { [Faraday::ConnectionFailed, "Message"] }

        it do
          expect(cli.messages).to receive(:no_service)
          subject
        end
      end
    end
  end
end
