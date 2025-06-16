class AttachmentValidator < ActiveModel::EachValidator
  include ActiveSupport::NumberHelper

  def validate_each(record, attribute, value)
    return if value.blank? || !value.attached?

    has_error = false

    if options[:content_type]
      if value.is_a?(ActiveStorage::Attached::Many)
        value.each do |file|
          has_error = true unless validate_content_type(record, attribute, file)
          break
        end
      else
        has_error = true unless validate_content_type(record, attribute, value)
      end
    end

    if options[:maximum]
      if value.is_a?(ActiveStorage::Attached::Many)
        value.each do |file|
          has_error = true unless validate_maximum(record, attribute, file)
          break
        end
      else
        has_error = true unless validate_maximum(record, attribute, value)
      end
    end

    record.send(attribute).purge if options[:purge] && has_error
  end

  private

  def validate_content_type(record, attribute, value)
    if value.content_type.match?(options[:content_type])
      true
    else
      record.errors[attribute] << (options[:message] || 'は対応できないファイル形式です')
      false
    end
  end

  def validate_maximum(record, attribute, value)
    if value.byte_size < options[:maximum]
      true
    else
      record.errors[attribute] << (options[:message] || "は#{number_to_human_size(options[:maximum])}以下にして下さい")
      false
    end
  end
end
