# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe Wrapper do
  before(:each) do
    response = { error: 'No activity found with the specified parameters' }
    stub_request(:get, 'https://www.boredapi.com/api/activity')
      .to_return(status: 200, body: response.to_json)
  end

  let(:wrapper) { described_class.new }

  describe 'too_many_perticipants' do
    it 'fetches and displays the API response based on command line options wit many participants' do
      options = [
        '--type', 'education',
        '--participants', '5',
        '--price_min', '0',
        '--price_max', '0.5',
        '--accessibility_min', '0.1',
        '--accessibility_max', '0.3'
      ]

      output = capture_output { wrapper.invoke(:new, options) }

      expect(output).to include('No activity found with the specified parameters')
      expect(output).to include('No activity saved')
    end
  end

  describe 'price_out_of_range' do
    it 'fetches and displays the API response based on command line options wit price out of range' do
      options = [
        '--type', 'education',
        '--participants', '1',
        '--price_min', '10',
        '--price_max', '50',
        '--accessibility_min', '0.1',
        '--accessibility_max', '0.3'
      ]

      output = capture_output { wrapper.invoke(:new, options) }

      expect(output).to include('No activity found with the specified parameters')
      expect(output).to include('No activity saved')
    end
  end
end
