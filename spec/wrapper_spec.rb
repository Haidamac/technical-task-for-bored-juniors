# frozen_string_literal: true

require 'webmock/rspec'

RSpec.describe Wrapper do
  let(:wrapper) { described_class.new }

  describe 'validate participants' do
    it 'returns nil when participants are valid' do
      expect(wrapper.send(:validate_participants, 2)).to be_nil
    end

    it 'returns an error message when participants are invalid' do
      expect do
        wrapper.send(:validate_participants, 0)
      end.to output(/Number of participants must be greater than 0/).to_stdout
    end
  end

  describe 'validate range' do
    it 'returns nil when the value is within the range' do
      expect(wrapper.send(:validate_range, 0.5, 0.0, 1.0, 'Error message')).to be_nil
    end

    it 'returns an error message when the value is outside the range' do
      expect do
        wrapper.send(:validate_range, 1.5, 0.0, 1.0, 'Error message')
      end.to output(/Error message/).to_stdout
    end
  end

  describe 'output check' do
    before do
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

  describe 'values_validation' do
    before do
      response = { error: 'No activity found with the specified parameters' }
      stub_request(:get, 'https://www.boredapi.com/api/activity')
        .to_return(status: 200, body: response.to_json)
    end

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

  describe 'new options validation' do
    before do
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

    it 'validates permitted options' do
      options = [
        '--type', 'relaxation'
      ]

      expect { wrapper.invoke(:new, options) }.not_to raise_error
    end
  end

  describe 'empty database' do
    it 'doesnt raise an error' do
      expect { wrapper.invoke(:list) }.not_to raise_error
    end
  end

  describe 'list successfully' do
    let!(:activity1) {{
      activity: 'Test Activity',
      type: 'relaxation',
      participants: 1,
      price: 0.1,
      link: 'https://example.com/',
      key: '123456',
      accessibility: 0.1
    }}
    let!(:activity2) {{
        activity: 'Test Activity 2',
        type: 'relaxation',
        participants: 1,
        price: 0.5,
        link: 'https://example2.com/',
        key: '123456',
        accessibility: 0.4
     }}

    it 'doesnt raise an error' do
      expect { wrapper.invoke(:list) }.not_to raise_error
    end
  end
end
