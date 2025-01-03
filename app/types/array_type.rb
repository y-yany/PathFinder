class ArrayType < ActiveModel::Type::Value
  def cast(value)
    return [] unless value.is_a?(String)

    begin
      JSON.parse(value)
    rescue JSON::ParserError
      []
    end
  end
end
