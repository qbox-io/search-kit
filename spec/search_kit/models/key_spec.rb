require 'spec_helper'

describe SearchKit::Models::Key do
  let(:model) { described_class.new }

  subject { model }

  it { is_expected.to be_instance_of SearchKit::Models::Key }
  it { is_expected.to respond_to :uri }
  it { is_expected.to respond_to :token }
  it { is_expected.to respond_to :name }

  describe '#creator?' do
    subject { model.creator? }
    
    context 'when #privilege is set to "creator"' do
      before { model.privilege = 'creator' }
      it { is_expected.to be true }
    end

    context 'otherwise' do
      it { is_expected.to be false }
    end
  end

end
