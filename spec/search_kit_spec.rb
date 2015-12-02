require 'spec_helper'

describe SearchKit do
  it 'has a version number' do
    expect(described_class.gem_version).not_to be nil
  end

  describe '#logger=' do
    let(:logger) { Logger.new('log/test.log', 'daily') }
    before { described_class.logger = logger }
    subject { described_class.logger }
    it { is_expected.to eq logger }
  end
end
