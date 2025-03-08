class DistanceValidator < ActiveModel::Validator
  def validate(record)
    return unless record.min_distance && record.max_distance
    return if record.min_distance <= record.max_distance

    record.errors.add :base, "距離の範囲に誤りがあります"
  end
end
