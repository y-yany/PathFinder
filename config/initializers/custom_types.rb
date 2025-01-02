Rails.application.config.after_initialize do
  ActiveModel::Type.register(:array, ArrayType)
end