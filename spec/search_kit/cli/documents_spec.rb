require 'spec_helper'

describe SearchKit::CLI::Documents do
  let(:cli)      { described_class.new }
  let(:json)     { response.to_json }
  let(:response) { {} }
  let(:slug)     { "an-index-slug" }

  subject { cli }

  describe '#create' do
    before { allow(cli.client).to receive(:create).and_return(response) }

    subject { cli.create(slug, json) }

    it "parses the given document json" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    it "calls client.create with the slug and document" do
      expect(cli.client).to receive(:create).with(slug, {})
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(response.to_json)
      subject
    end

    context 'when given bad json' do
      let(:json) { "Arglebargle" }
      it "reports an error" do
        expect(cli.messages).to receive(:json_parse_error)
        subject
      end
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:create).and_raise(*error) }

      context 'not found error' do
        let(:error) { SearchKit::Errors::IndexNotFound }

        it do
          expect(cli.messages).to receive(:not_found)
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

  describe '#delete' do
    let(:id) { 1 }

    before { allow(cli.client).to receive(:delete).and_return(response) }

    subject { cli.delete(slug, id) }

    it "calls client.create with the slug and document" do
      expect(cli.client).to receive(:delete).with(slug, id)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(response.to_json)
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:delete).and_raise(*error) }

      context 'not found error' do
        let(:error) { SearchKit::Errors::IndexNotFound }

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

  describe '#show' do
    let(:id) { 1 }

    before { allow(cli.client).to receive(:show).and_return(response) }

    subject { cli.show(slug, id) }

    it "calls client.create with the slug and document" do
      expect(cli.client).to receive(:show).with(slug, id)
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(response.to_json)
      subject
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:show).and_raise(*error) }

      context 'not found error' do
        let(:error) { SearchKit::Errors::IndexNotFound }

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

  describe '#update' do
    let(:id) { 1 }

    before { allow(cli.client).to receive(:update).and_return(response) }

    subject { cli.update(slug, id, json) }

    it "parses the given document json" do
      expect(JSON).to receive(:parse).with(json, symbolize_names: true)
      subject
    end

    it "calls client.create with the slug and document" do
      expect(cli.client).to receive(:update).with(slug, id, {})
      subject
    end

    it "reports on its results" do
      expect(cli.messages).to receive(:info).with(response.to_json)
      subject
    end

    context 'when given bad json' do
      let(:json) { "Arglebargle" }
      it "reports an error" do
        expect(cli.messages).to receive(:json_parse_error)
        subject
      end
    end

    context 'error handling' do
      before { allow(cli.client).to receive(:update).and_raise(*error) }

      context 'not found error' do
        let(:error) { SearchKit::Errors::IndexNotFound }

        it do
          expect(cli.messages).to receive(:not_found)
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
end
