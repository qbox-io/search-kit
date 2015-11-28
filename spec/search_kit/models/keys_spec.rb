require 'spec_helper'

describe SearchKit::Models::Keys do
  let(:creator_key) do
    SearchKit::Models::Key.new(
      attributes: {
        privilege: 'creator',
        token:     creator_token
      }
    )
  end

  let(:consumer_key) do
    SearchKit::Models::Key.new(
      attributes: {
        privilege: 'consumer',
        token:     consumer_token
      }
    )
  end

  let(:creator_token)  { "12345" }
  let(:consumer_token) { "67890" }
  let(:keys)           { [ creator_key, consumer_key ] }
  let(:model)          { described_class.new(keys) }

  subject { model }

  describe "#creator" do
    subject { model.creator }
    it { is_expected.to be_instance_of described_class }
    it { is_expected.to match described_class.new([creator_key]) }
  end

  describe "#tokens" do
    subject { model.tokens }
    it { is_expected.to match [creator_token, consumer_token] }
  end
end
