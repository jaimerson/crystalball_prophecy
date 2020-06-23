# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CrystalballProphecyDataSource do
  subject(:data_source) { described_class.new }

  after do
    data_source.clear!
  end

  describe 'getter and setter' do
    it 'returns empty array when there is no value' do
      expect(data_source['key_that_is_not_stored']).to eq([])
    end

    it 'allows getting and setting values' do
      data_source['spec/some_spec.rb'] = %w[app/some_file.rb app/some_other_file.rb]
      expect(data_source['app/some_file.rb']).to match(%w[spec/some_spec.rb])
      data_source['spec/some_other_spec.rb'] = %w[app/some_file.rb app/bar.rb]
      expect(data_source['app/some_file.rb']).to match(%w[spec/some_spec.rb spec/some_other_spec.rb])
    end
  end

  describe '#affected_examples_for' do
    it 'returns affected examples for single file' do
      data_source['spec/some_spec.rb'] = %w[app/some_file.rb app/some_other_file.rb]
      data_source['spec/some_other_spec.rb'] = %w[app/some_file.rb app/bar.rb]
      expect(data_source.affected_examples_for('app/some_file.rb')).to eq(%w[spec/some_spec.rb spec/some_other_spec.rb])
    end

    it 'returns affected examples for list of files' do
      data_source['spec/some_spec.rb'] = %w[app/some_file.rb app/some_other_file.rb]
      data_source['spec/some_other_spec.rb'] = %w[app/some_file.rb app/bar.rb]
      data_source['spec/yet_another_spec.rb'] = %w[app/bar.rb]
      expect(data_source.affected_examples_for(%w[app/some_file.rb app/bar.rb])).to eq(%w[spec/some_spec.rb spec/some_other_spec.rb spec/yet_another_spec.rb])
    end
  end

  # To be deprecated in Crystalball
  describe '#examples' do
    it 'returns all stored examples' do
      data_source['spec/some_spec.rb'] = %w[app/some_file.rb app/some_other_file.rb]
      data_source['spec/some_other_spec.rb'] = %w[app/some_file.rb app/bar.rb]
      expect(data_source.examples).to match(%w[spec/some_spec.rb spec/some_other_spec.rb])
    end
  end

  # To be deprecated in Crystalball
  describe '#example_groups' do
    it 'returns all stored examples' do
      data_source['spec/some_spec.rb'] = %w[app/some_file.rb app/some_other_file.rb]
      data_source['spec/some_other_spec.rb'] = %w[app/some_file.rb app/bar.rb]
      expect(data_source.example_groups).to match({
                                                    'app/some_file.rb' => %w[spec/some_spec.rb spec/some_other_spec.rb],
                                                    'app/some_other_file.rb' => %w[spec/some_spec.rb],
                                                    'app/bar.rb' => %w[spec/some_other_spec.rb]
                                                  })
    end
  end
end
