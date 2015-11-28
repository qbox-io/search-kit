require 'spec_helper'

describe SearchKit::Configuration do
  let(:klass) { Class.new }

  before { klass.extend(described_class) }

  subject { klass }

  it { is_expected.to respond_to :config }
  it { is_expected.to respond_to :configure }

  describe "Arbitrary assignment" do
    it "allows any arbitrary setting to hold a value" do
      expect {
        klass.configure do |config|
          config.arbitrary_setting = "value"
        end
      }.to change { klass.config.arbitrary_setting }
        .from(nil)
        .to("value")
    end
  end

end
