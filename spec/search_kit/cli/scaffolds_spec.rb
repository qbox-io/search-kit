require 'spec_helper'

describe SearchKit::CLI::Scaffolds do
  let(:cli)      { described_class.new }
  let(:json)     { response.to_json }
  let(:response) { {} }
  let(:slug)     { "an-index-slug" }

  subject { cli }

  describe '#create' do
    let(:documents)      { [{ title: "Yep", id: 1 }] }
    let(:documents_json) { documents.to_json }
    let(:name)           { "Index Name" }

    before { allow(cli.client).to receive(:create).and_return(response) }

    subject { cli.create(name, documents_json) }

    it "calls client.create with the index name" do
      expect(cli.client).to receive(:create).with(name, documents)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
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

      context 'json error' do
        let(:error) { JSON::ParserError }

        it do
          expect(cli.messages).to receive(:json_parse_error)
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
