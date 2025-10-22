# == Schema Information
#
# Table name: fields
#
#  id         :bigint           not null, primary key
#  field_type :integer          default(0), not null
#  max_length :integer
#  max_value  :integer
#  min_length :integer
#  min_value  :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_fields_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class FieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
