class CreateEntryService
  def initialize(form, entry_values_params)
    @form = form
    @entry_values_params = entry_values_params
  end

  def call
    @form_entry = @form.form_entries.build

    build_entry_values

    @form_entry
  end

  private

  def build_entry_values
    return if @entry_values_params.blank?

    @entry_values_params.each do |form_field_id, value|
      form_field = @form.form_fields.find(form_field_id)

      entry_value = @form_entry.entry_values.build(form_field: form_field)
      entry_value.value = value
    end
  end
end
