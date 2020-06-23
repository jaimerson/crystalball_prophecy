# frozen_string_literal: true

class CrystalballProphecyStorage
  class <<self
    # @param [Pathname] path to load
    # @return [Array<Hash, CrystalballProphecyDataSource>]
    def load(path)
      metadata = {}
      data_source = CrystalballProphecyDataSource.new
      line_type = nil

      File.foreach(path) do |line|
        line.strip!
        case line
        when /BEGIN_METADATA/ then line_type = :metadata
        when /END_METADATA/ then line_type = :dictionary
        else
          if line_type == :metadata
            set_metadata(metadata, line)
          elsif line_type == :dictionary
            data_source.set_dictionary(line)
            line_type = :data
          else
            key, values = line.split(':')
            data_source.set_encoded(key, values)
          end
        end
      end

      [metadata, data_source]
    end

    private

    def set_metadata(metadata, line)
      key, value = line.split(',')
      metadata[key.to_sym] = value
    end
  end
end
