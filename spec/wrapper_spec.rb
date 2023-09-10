# frozen_string_literal: true

RSpec.describe Wrapper do
  let(:wrapper) { described_class.new }

  describe 'validate_participants' do
    it 'returns nil when participants are valid' do
      expect(wrapper.send(:validate_participants, 2)).to be_nil
    end

    it 'returns an error message when participants are invalid' do
      expect do
        wrapper.send(:validate_participants, 0)
      end.to output(/Number of participants must be greater than 0/).to_stdout
    end
  end

  describe 'validate_range' do
    it 'returns nil when the value is within the range' do
      expect(wrapper.send(:validate_range, 0.5, 0.0, 1.0, 'Error message')).to be_nil
    end

    it 'returns an error message when the value is outside the range' do
      expect do
        wrapper.send(:validate_range, 1.5, 0.0, 1.0, 'Error message')
      end.to output(/Error message/).to_stdout
    end
  end
end
