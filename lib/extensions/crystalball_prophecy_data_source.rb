# frozen_string_literal: true

module DataSourceExtensions
  def get(*)
    super.split(',')
  end

  def keys
    super.split(',')
  end
end

class CrystalballProphecyDataSource
  prepend DataSourceExtensions

  alias [] get
  alias []= set
end
