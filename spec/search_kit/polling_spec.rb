require 'spec_helper'

describe SearchKit::Polling do
  let(:channel) { 'mail' }
  let(:block)   { Proc.new { |x| true } }
  let(:service) { described_class.new(channel, &block) }

  subject { service }

  it { is_expected.to respond_to :channel }
  it { is_expected.to respond_to :block }

  describe '#process_queue' do
    subject { service.process_queue }

    it "performs a Process action" do
      expect(SearchKit::Polling::Process)
        .to receive(:perform)
        .with(channel, &block)

      subject
    end
  end
end
