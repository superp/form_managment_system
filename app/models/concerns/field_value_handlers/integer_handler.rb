class FieldValueHandlers::IntegerHandler < FieldValueHandler
  def validate_constraints(entry_value)
    field = entry_value.field

    return if field.min_value.blank? || field.max_value.blank?
    return if entry_value.integer_value.blank?
    return if entry_value.integer_value.between?(field.min_value, field.max_value)

    entry_value.errors.add(:integer_value, "#{field.name} must be between #{field.min_value} and #{field.max_value}")
  end
end
