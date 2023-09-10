# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe Wrapper do
  before(:each) do
    response = {
      activity: 'Test Activity',
      type: 'relaxation',
      participants: 1,
      price: 0.1,
      link: 'https://example.com/',
      key: '123456',
      accessibility: 0.1
    }
    stub_request(:get, 'https://www.boredapi.com/api/activity')
      .to_return(status: 200, body: response.to_json)
  end

  let(:wrapper) { described_class.new }

  describe 'new' do
    it 'fetches and displays the API response based on command line options' do
      options = [
        '--type', 'relaxation',
        '--participants', '1',
        '--price_min', '0',
        '--price_max', '0.5',
        '--accessibility_min', '0.1',
        '--accessibility_max', '0.3'
      ]

      output = capture_output { wrapper.invoke(:new, options) }

      expect(output).to include('Your random activity:')
      expect(output).to include('type: relaxation')
      expect(output).to include('participants: 1')
    end
  end
end
