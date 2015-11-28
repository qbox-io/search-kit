require 'spec_helper'

describe "Modeling incoming subscriber data" do
  let(:subscriber_id) { "5659f64d21de3bfe6c000004" }
  let(:subscriber_email) { "joseph@qbox.io" }
  let(:subscriber_uri) { "/api/subscribers" }

  let(:key_token) { "2bad61a9ea4f5adf1d36952e59ddda2b" }
  let(:key_name) { "Universal access key" }
  let(:key_id) { "5659f64d21de3bfe6c000005" }
  let(:key_uri) { "/api/keys/5659f64d21de3bfe6c000005" }

  let(:response) do
    {
      data: {
        type:       "subscribers",
        id:         subscriber_id,
        attributes: { id: subscriber_id, email: subscriber_email },
        links:      { self: subscriber_uri },
        relationships: {
          keys: [
            {
              type: "keys",
              id:   key_id,
              attributes: {
                id:        key_id,
                name:      key_name,
                token:     key_token,
                privilege: "creator"
              },
              links: { self: key_uri }
            }
          ]
        }
      }
    }
  end

  let(:subscriber) do
    SearchKit::Models::Subscriber.new(response.fetch(:data))
  end

  subject { subscriber }

  describe '#creator_tokens' do
    subject { subscriber.creator_tokens.first }
    it { is_expected.to eq key_token }
  end

  describe '#email' do
    subject { subscriber.email }
    it { is_expected.to eq subscriber_email }
  end

  describe '#id' do
    subject { subscriber.id }
    it { is_expected.to eq subscriber_id }
  end

  describe '#keys' do
    let(:key) { subscriber.keys.first }

    subject { key }

    describe '#id' do
      subject { key.id }
      it { is_expected.to eq key_id }
    end

    describe '#name' do
      subject { key.name }
      it { is_expected.to eq key_name }
    end

    describe '#token' do
      subject { key.token }
      it { is_expected.to eq key_token }
    end

    describe '#uri' do
      subject { key.uri }
      it { is_expected.to eq key_uri }
    end
  end

  describe '#uri' do
    subject { subscriber.uri }
    it { is_expected.to eq subscriber_uri }
  end

end
