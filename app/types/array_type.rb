class ArrayType < ActiveModel::Type::Value
  def cast(value)
    return [] unless value.is_a?(String) || value.is_a?(Array)

    if value.is_a?(String)
      begin
        JSON.parse(value)
      rescue JSON::ParserError
        []
      end
    elsif value.is_a?(Array)
      value.reject { |item| item == "" }
    end
  end
end
