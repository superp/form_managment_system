# == Schema Information
#
# Table name: form_entries
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  form_id    :bigint           not null
#
# Indexes
#
#  index_form_entries_on_form_id  (form_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_id => forms.id)
#
require "test_helper"

class FormEntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
