class FormFieldPresenter
  attr_reader :form_field, :entry_value

  delegate :field_name, to: :form_field
  delegate :field_type, to: :form_field

  def initialize(form_field, entry_value = nil)
    @form_field = form_field
    @entry_value = entry_value
  end

  def current_value
    return "" if entry_value.blank?

    entry_value.value
  end

  def placeholder
    case field_type.to_s
    when "string"
      "Enter text (#{field.min_length}-#{field.max_length} characters)"
    when "integer"
      "Enter number (#{field.min_value}-#{field.max_value})"
    when "datetime"
      "Select date and time"
    else
      "Enter value"
    end
  end

  def input_type
    case field_type
    when "string"
      "text"
    when "integer"
      "number"
    when "datetime"
      "datetime-local"
    else
      "text"
    end
  end

  def validation_attributes
    case field_type
    when "string"
      {
        minlength: field.min_length,
        maxlength: field.max_length
      }
    when "integer"
      {
        min: field.min_value,
        max: field.max_value
      }
    else
      {}
    end
  end

  def formatted_datetime_value
    return "" if current_value.blank?

    case current_value
    when String
      current_value
    when Time, DateTime
      current_value.strftime("%Y-%m-%dT%H:%M")
    else
      ""
    end
  end

  private

  def field
    @field ||= form_field.field
  end
end
