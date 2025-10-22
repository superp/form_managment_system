class FieldValueHandler
  def validate_presence(entry_value)
    value = get_value(entry_value)
    return if value.present?

    field_name = entry_value.field.name
    entry_value.errors.add(entry_value.value_attribute_name, "#{field_name} can't be blank")
  end

  def validate_constraints(entry_value)
    # Override in subclasses for specific validation logic
  end

  def get_value(entry_value)
    entry_value.public_send(entry_value.value_attribute_name)
  end

  def set_value(entry_value, val)
    entry_value.public_send("#{entry_value.value_attribute_name}=", val)
  end
end
