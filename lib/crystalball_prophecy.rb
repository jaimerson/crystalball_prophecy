# frozen_string_literal: true

require 'helix_runtime'

begin
  require 'crystalball_prophecy/native'
rescue LoadError
  warn 'Unable to load crystalball_prophecy/native. Please run `rake build`'
end

require 'extensions/crystalball_prophecy_data_source'
require 'crystalball_prophecy/crystalball_prophecy_storage'
