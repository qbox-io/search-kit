require 'spec_helper'

describe SearchKit::Events::Poll::Process do
  let(:block) { -> x { true } }
  let(:channel) { "mail" }
  let(:process) { described_class.new(channel, &block) }

  subject { process }

  it { is_expected.to respond_to :channel }
  it { is_expected.to respond_to :client }
  it { is_expected.to respond_to :block }

  describe '#perform' do
    let(:event_id) { 345 }
    let(:event) do
      {
        data: [{
          type: 'events',
          id: event_id,
          attributes: {
            channel: channel,
            payload: { id: event_id, title: "Gee willikers" }
          }
        }]
      }
    end

    before do
      allow(process.client).to receive(:pending).and_return(event)
      allow(process.client).to receive(:complete)
    end

    subject { process.perform }

    it "calls the block with every event" do
      expect(process.block)
        .to receive(:call)
        .and_return(process.block)
        .with(instance_of(OpenStruct))
        .once

      subject
    end

    it "completes the event" do
      expect(process.client)
        .to receive(:complete)
        .with(event_id)
        .once

      subject
    end

    context "if something fails" do
      let(:block) do
        -> * { fail("Generic failure") }
      end

      it "raises an exception" do
        expect { subject }.to raise_exception(StandardError)
      end
    end
  end
end
