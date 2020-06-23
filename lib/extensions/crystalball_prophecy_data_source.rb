# frozen_string_literal: true

module DataSourceExtensions
  def get(*)
    super.split(',')
  end

  def affected_examples_for(files)
    super(Array(files).join(',')).split(',')
  end

  def examples
    super.split(',')
  end

  def example_groups
    super.split(';').map do |line|
      puts line
      values = line.split(',')
      [values.shift, values]
    end.to_h
  end

  def set(key, values)
    super(key, values.join(','))
  end

  def keys
    super.split(',')
  end
end

class CrystalballProphecyDataSource
  prepend DataSourceExtensions

  alias [] get
  alias []= set
  alias clear! clear

  private :get, :set, :clear
end
