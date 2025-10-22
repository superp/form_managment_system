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
class FormEntry < ApplicationRecord
  belongs_to :form
  has_many :entry_values, dependent: :destroy

  delegate :user, to: :form

  scope :ordered, -> { order(:created_at) }

  accepts_nested_attributes_for :entry_values, allow_destroy: true

  def entry_number
    form.form_entries.where('created_at <= ?', created_at).count
  end
end
