module FormResultsHelper
  def render_form_results_table(form_fields, form_entries)
    content_tag :table, class: 'form-results-table' do
      render_table_header(form_entries) +
        render_table_body(form_fields, form_entries)
    end
  end

  def render_table_header(form_entries)
    content_tag :thead do
      content_tag :tr do
        content_tag(:th, 'Field Name') +
          form_entries.map.with_index(1) do |_entry, index|
            content_tag(:th, "Entry ##{index}")
          end.join.html_safe
      end
    end
  end

  def render_table_body(form_fields, form_entries)
    content_tag :tbody do
      form_fields.map do |form_field|
        render_form_field_row(form_field, form_entries)
      end.join.html_safe
    end
  end

  def render_form_field_row(form_field, form_entries)
    content_tag :tr do
      content_tag(:td, form_field.field_name, class: 'field-name') +
        form_entries.map do |form_entry|
          entry_value = form_entry.entry_values.find_by(form_field: form_field)
          content_tag(:td, format_entry_value(entry_value), class: 'entry-value')
        end.join.html_safe
    end
  end

  def format_entry_value(entry_value)
    return '-' if entry_value.blank?

    entry_value.value
  end

  def download_csv_link(form)
    link_to 'Download CSV', results_form_path(form, format: :csv),
            class: 'button', target: '_blank'
  end
end
