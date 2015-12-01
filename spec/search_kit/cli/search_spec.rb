require 'spec_helper'

describe SearchKit::CLI::Search do
  let(:cli)      { described_class.new }
  let(:json)     { response.to_json }
  let(:phrase)   { "Michael Jackson" }
  let(:response) { SearchKit::Models::Search.new }
  let(:slug)     { "an-index-slug" }

  subject { cli }

  describe '#create' do
    before { allow(cli.client).to receive(:create).and_return(response) }

    subject { cli.create(slug, phrase) }

    it "calls client.search with the slug, and phrase" do
      expect(cli.client).to receive(:create).with(slug, phrase: phrase)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String)).twice
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:create).and_raise(*error) }

      context 'unauthorized error' do
        let(:error) { SearchKit::Errors::Unauthorized }

        it do
          expect(cli.messages).to receive(:unauthorized)
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

      context 'bad request error' do
        let(:error) { SearchKit::Errors::BadRequest }

        it do
          expect(cli.messages).to receive(:bad_request)
          subject
        end
      end

      context 'not found error' do
        let(:error) { SearchKit::Errors::IndexNotFound }

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
