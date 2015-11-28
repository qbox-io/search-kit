require 'spec_helper'

describe SearchKit::Models::Subscriber do
  let(:model) { described_class.new }

  subject { model }

  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :uri }

  describe '#creator_tokens' do
    subject { model.creator_tokens }
    it { is_expected.to be_instance_of Array }
  end

  describe '#keys' do
    subject { model.keys }
    it { is_expected.to be_instance_of SearchKit::Models::Keys }
  end

end
