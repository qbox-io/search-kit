require 'spec_helper'

describe SearchKit::CLI::Indices do
  let(:cli)      { described_class.new }
  let(:json)     { response.to_json }
  let(:response) { {} }
  let(:slug)     { "an-index-slug" }

  subject { cli }

  describe '#archive' do
    before { allow(cli.client).to receive(:archive).and_return(response) }

    subject { cli.archive(slug) }

    it "calls client.complete with the index slug" do
      expect(cli.client).to receive(:archive).with(slug)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:archive).and_raise(*error) }

      context 'unauthorized error' do
        let(:error) { SearchKit::Errors::Unauthorized }

        it do
          expect(cli.messages).to receive(:unauthorized)
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

  describe '#create' do
    let(:name) { "Index Name" }

    before { allow(cli.client).to receive(:create).and_return(response) }

    subject { cli.create(name) }

    it "calls client.create with the index name" do
      expect(cli.client).to receive(:create).with(name)
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

      context 'no service error' do
        let(:error) { [Faraday::ConnectionFailed, "Message"] }

        it do
          expect(cli.messages).to receive(:no_service)
          subject
        end
      end
    end
  end

  describe '#show' do
    before { allow(cli.client).to receive(:show).and_return(response) }

    subject { cli.show(slug) }

    it "calls client.show with the index slug" do
      expect(cli.client).to receive(:show).with(slug)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:show).and_raise(*error) }

      context 'unauthorized error' do
        let(:error) { SearchKit::Errors::Unauthorized }

        it do
          expect(cli.messages).to receive(:unauthorized)
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

  describe '#update' do
    let(:update)      { { name: "New Name" } }
    let(:update_json) { update.to_json }

    before { allow(cli.client).to receive(:update).and_return(response) }

    subject { cli.update(slug, update_json) }

    it "calls client.update with the index slug and given json" do
      expect(cli.client).to receive(:update).with(slug, update)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(an_instance_of(String))
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:update).and_raise(*error) }

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
