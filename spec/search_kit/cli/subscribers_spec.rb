require 'spec_helper'

describe SearchKit::CLI::Subscribers do
  let(:cli)        { described_class.new }
  let(:subscriber) { SearchKit::Models::Subscriber.new }

  subject { cli }

  describe '#create' do
    let(:email)    { "email@example.com" }
    let(:password) { "password" }

    before { allow(cli.client).to receive(:create).and_return(subscriber) }

    subject { cli.create(email, password) }

    it "calls create on the client with the given parameters" do
      expect(cli.client)
        .to receive(:create)
        .with(email: email, password: password)

      subject
    end

    it "sends a message that the subscriber has been created" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    describe 'error handling' do
      before { allow(cli.client).to receive(:create).and_raise(*error) }

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

  describe '#info' do
    before { allow(cli.client).to receive(:info).and_return(subscriber) }

    subject { cli.info }

    it "calls info on the client" do
      expect(cli.client).to receive(:info)
      subject
    end

    it "sends a message that the subscriber has been created" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    describe 'error handling' do
      before { allow(cli.client).to receive(:info).and_raise(*error) }

      context 'unprocessable error' do
        let(:error) { SearchKit::Errors::Unauthorized }

        it do
          expect(cli.messages).to receive(:unauthorized)
          subject
        end
      end

      context 'not found error' do
        let(:error) { SearchKit::Errors::SubscriberNotFound }

        it do
          expect(cli.messages).to receive(:not_found)
          subject
        end
      end

      context 'no service error' do
        let(:error) { [Faraday::ConnectionFailed, "Message"] }

        it do
          expect(cli.messages).to receive(:no_service)
          subject
        end
      end
    end
  end
end
