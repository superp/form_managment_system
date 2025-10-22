# == Schema Information
#
# Table name: forms
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_forms_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Form < ApplicationRecord
  belongs_to :user
  has_many :form_fields, dependent: :destroy
  has_many :fields, through: :form_fields
  has_many :form_entries, dependent: :destroy

  accepts_nested_attributes_for :form_fields, allow_destroy: true

  validates :title, presence: true

  scope :ordered, -> { order(:created_at) }
end
