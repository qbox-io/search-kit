require 'spec_helper'

describe SearchKit::Models::Document do
  let(:document_data) { {} }
  let(:document) { described_class.new(document_data) }

  subject { document }

  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :source }
  it { is_expected.to respond_to :score }

  describe '#get' do
    let(:key) { :a_key }

    subject { document.get(key) }

    context 'when the source has the available content' do
      let(:content)       { :key_content }
      let(:document_data) { { source: { key => content } } }

      it "returns the content" do
        expect(subject).to eq content
      end

      context 'method missing coverage' do
        it { expect(document).to respond_to :a_key }
        it { expect(document.a_key).to eq content }
      end
    end

    context 'otherwise' do
      it "raises an attribute not found error" do
        expect { subject }
          .to raise_exception(described_class::AttributeNotFound)
      end

      context 'method missing coverage' do
        it { expect(document).not_to respond_to :a_key }
        it { expect { document.a_key }.to raise_exception(NoMethodError) }
      end
    end
  end
end
