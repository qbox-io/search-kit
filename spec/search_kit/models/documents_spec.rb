require 'spec_helper'

describe SearchKit::Models::Documents do
  let(:document_data) { [{}] }
  let(:documents)     { described_class.new(document_data) }

  subject { documents }

  it { is_expected.to respond_to :contents }
  it { is_expected.to respond_to :each }

end
