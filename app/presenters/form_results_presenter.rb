class FormResultsPresenter
  attr_reader :form, :form_fields, :form_entries

  def initialize(form, form_fields, form_entries)
    @form = form
    @form_fields = form_fields
    @form_entries = form_entries
  end

  def has_entries?
    form_entries.any?
  end

  def entries_count
    form_entries.count
  end

  def fields_count
    form_fields.count
  end

  def table_data
    form_fields.map do |form_field|
      {
        field_name: form_field.field_name,
        entries: form_entries.map do |form_entry|
          entry_value = form_entry.entry_values.find_by(form_field: form_field)
          entry_value.value
        end
      }
    end
  end

  def csv_data
    [header_row] + data_rows
  end

  private

  def header_row
    ['Field Name'] + form_entries.map.with_index(1) { |_entry, index| "Entry #{index}" }
  end

  def data_rows
    form_fields.map do |form_field|
      [form_field.field_name] + form_entries.map do |form_entry|
        entry_value = form_entry.entry_values.find_by(form_field: form_field)
        format_entry_value(entry_value)
      end
    end
  end

  def format_entry_value(entry_value)
    return '' if entry_value.blank?

    case entry_value.field_type
    when 'string'
      entry_value.string_value
    when 'integer'
      entry_value.integer_value
    when 'datetime'
      entry_value.datetime_value&.strftime('%Y-%m-%d %H:%M')
    else
      entry_value.value
    end
  end
end
