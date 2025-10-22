class UpdateEntryService
  def initialize(form_entry, entry_values_params)
    @form_entry = form_entry
    @entry_values_params = entry_values_params
  end

  def call
    build_entry_values
    @form_entry
  end

  private

  def build_entry_values
    return if @entry_values_params.blank?

    @entry_values_params.each do |form_field_id, value|
      entry_value = @form_entry.entry_values.find_or_initialize_by(form_field_id: form_field_id)

      entry_value.value = value
      entry_value.save
    end
  end
end
