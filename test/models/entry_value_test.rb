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
require "test_helper"

class EntryValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
