require 'spec_helper'

describe SearchKit::Models::Events do
  let(:event_data) { [{}] }
  let(:events)     { described_class.new(event_data) }

  subject { events }

  it { is_expected.to respond_to :contents }
  it { is_expected.to respond_to :each }

end
