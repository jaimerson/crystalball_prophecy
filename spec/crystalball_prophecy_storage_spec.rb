# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe CrystalballProphecyStorage do
  describe '.load' do
    subject(:load!) { described_class.load(file.path) }
    let(:file) do
      f = Tempfile.open
      f.write(input_string)
      f.flush
      f
    end

    after do
      file.close
      file.unlink
    end

    let(:input_string) do
      <<~STR
        [BEGIN_METADATA]
        commit,a420ff69
        type,Crystalball::ExecutionMap
        version,1
        [END_METADATA]
        app,models,user.rb,spec,user_spec.rb,post.rb,post_spec.rb,other_model.rb,integration,other_model_spec.rb
        0/1/2:3/1/4,3/1/6
        0/1/5:3/1/6
        0/1/7:3/8/9
      STR
    end

    it 'loads the metadata and the data source' do
      metadata, map_data_source = load!
      expect(metadata).to eq({
                               commit: 'a420ff69',
                               type: 'Crystalball::ExecutionMap',
                               version: '1'
                             })
      expect(map_data_source.affected_examples_for('app/models/user.rb'))
        .to eq(%w[spec/models/user_spec.rb spec/models/post_spec.rb])
      expect(map_data_source.affected_examples_for('app/models/post.rb'))
        .to eq(%w[spec/models/post_spec.rb])
      expect(map_data_source.affected_examples_for('app/models/other_model.rb'))
        .to eq(%w[spec/integration/other_model_spec.rb])
    end
  end
  describe '#set_metadata'
  describe '#dump'
end
