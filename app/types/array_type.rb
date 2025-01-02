class ArrayType < ActiveModel::Type::Value
  def cast(value)
    return [] unless value.is_a?(String)

    JSON.parse(value)
  end
end
