class FieldValueHandlers::StringHandler < FieldValueHandler
  def validate_constraints(entry_value)
    field = entry_value.field
    return unless field.min_length && field.max_length
    return if entry_value.string_value.blank?

    length = entry_value.string_value.length
    return if length.between?(field.min_length, field.max_length)

    entry_value.errors.add(:string_value, "#{field.name} must be between #{field.min_length} and #{field.max_length} characters")
  end
end
