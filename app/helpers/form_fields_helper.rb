module FormFieldsHelper
  def render_form_field(form_field, entry_value = nil, form_name = 'entry_values')
    presenter = ::FormFieldPresenter.new(form_field, entry_value)
    field_id = form_field.id

    content_tag :div, class: 'field' do
      label_tag("#{form_name}[#{field_id}]", presenter.field_name) +
      render_field_input(presenter, field_id, form_name) +
      render_field_errors(entry_value)
    end
  end

  def render_field_errors(entry_value)
    return '' if entry_value.blank? || entry_value.errors.empty?

    content_tag :div, class: 'field-errors' do
      entry_value.errors.full_messages.map do |message|
        content_tag(:div, message, class: 'error-message')
      end.join.html_safe
    end
  end

  def render_field_input(presenter, field_id, form_name)
    input_options = {
      placeholder: presenter.placeholder,
      **presenter.validation_attributes
    }

    case presenter.field_type
    when 'string'
      text_field_tag("#{form_name}[#{field_id}]", presenter.current_value, input_options)
    when 'integer'
      number_field_tag("#{form_name}[#{field_id}]", presenter.current_value, input_options)
    when 'datetime'
      datetime_local_field_tag("#{form_name}[#{field_id}]", presenter.formatted_datetime_value, input_options)
    else
      text_field_tag("#{form_name}[#{field_id}]", presenter.current_value, input_options)
    end
  end
end
