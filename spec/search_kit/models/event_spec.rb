require 'spec_helper'

describe SearchKit::Models::Event do
  let(:event_data) { {} }
  let(:event) { described_class.new(event_data) }

  subject { event }

  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :channel }
  it { is_expected.to respond_to :payload }
  it { is_expected.to respond_to :state }

end
