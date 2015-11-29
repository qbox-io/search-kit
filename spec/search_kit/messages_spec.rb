require 'spec_helper'

describe SearchKit::Messages do
  let(:messages) { described_class.new }
  let(:message) { "Just about any string" }

  before do
    SearchKit.config.verbose = true

    allow(Kernel).to receive(:warn)
    allow(Kernel).to receive(:puts)
    allow(SearchKit.logger).to receive(:warn)
    allow(SearchKit.logger).to receive(:info)
  end

  after { SearchKit.config.verbose = false }

  describe "#info" do
    subject { messages.info(message) }

    it "warns in stderr" do
      expect(Kernel).to receive(:puts)
      subject
    end

    it "logs a warning" do
      expect(SearchKit.logger).to receive(:info).with(message)
      subject
    end
  end

  describe "#warning" do
    subject { messages.warning(message) }

    it "warns in stderr" do
      expect(Kernel).to receive(:warn)
      subject
    end

    it "logs a warning" do
      expect(SearchKit.logger).to receive(:warn).with(message)
      subject
    end
  end
end
