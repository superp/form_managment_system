# == Schema Information
#
# Table name: form_fields
#
#  id         :bigint           not null, primary key
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  field_id   :bigint           not null
#  form_id    :bigint           not null
#
# Indexes
#
#  index_form_fields_on_field_id  (field_id)
#  index_form_fields_on_form_id   (form_id)
#
# Foreign Keys
#
#  fk_rails_...  (field_id => fields.id)
#  fk_rails_...  (form_id => forms.id)
#
class FormField < ApplicationRecord
  belongs_to :form
  belongs_to :field
  has_many :entry_values, dependent: :destroy

  scope :ordered, -> { order(:position) }

  delegate :name, to: :field, prefix: true
  delegate :field_type, to: :field
end
