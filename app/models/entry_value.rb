# == Schema Information
#
# Table name: entry_values
#
#  id             :bigint           not null, primary key
#  datetime_value :datetime
#  integer_value  :integer
#  string_value   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  form_entry_id  :bigint           not null
#  form_field_id  :bigint           not null
#
# Indexes
#
#  index_entry_values_on_form_entry_id  (form_entry_id)
#  index_entry_values_on_form_field_id  (form_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_entry_id => form_entries.id)
#  fk_rails_...  (form_field_id => form_fields.id)
#
class EntryValue < ApplicationRecord
  HANDLERS = {
    'string' => FieldValueHandlers::StringHandler,
    'integer' => FieldValueHandlers::IntegerHandler,
    'datetime' => FieldValueHandlers::DatetimeHandler
  }.freeze

  belongs_to :form_entry
  belongs_to :form_field

  delegate :field, to: :form_field
  delegate :field_type, to: :field

  validates :form_field_id, uniqueness: { scope: :form_entry_id }

  # TODO: remove presence validation if not needed
  validate :validate_value_presence, :validate_value_constraints

  def value
    handler.get_value(self)
  end

  def value=(val)
    handler.set_value(self, val)
  end

  def value_attribute_name
    @value_attribute_name ||= case field_type.to_sym
                              when :string then :string_value
                              when :integer then :integer_value
                              when :datetime then :datetime_value
                              else raise ArgumentError, "Unknown field type: #{field_type}"
                              end
  end

  private

  def handler
    @handler ||= HANDLERS[field_type.to_s]&.new || raise(ArgumentError, "Unknown field type: #{field_type}")
  end

  def validate_value_presence
    handler.validate_presence(self)
  end

  def validate_value_constraints
    return unless field

    handler.validate_constraints(self)
  end
end
