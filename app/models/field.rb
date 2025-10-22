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
class Field < ApplicationRecord
  belongs_to :user
  has_many :form_fields, dependent: :destroy
  has_many :forms, through: :form_fields

  enum :field_type, {
    string: 0,
    integer: 1,
    datetime: 2
  }

  validates :name, presence: true
  validates :field_type, presence: true
  validates :min_length, :max_length, presence: true, if: :string?
  validates :min_value, :max_value, presence: true, if: :integer?
  validate :length_validation, if: :string?
  validate :value_validation, if: :integer?

  scope :ordered, -> { order(:name) }

  def name_with_type
    "#{name} (#{field_type.humanize})"
  end

  private

  def length_validation
    return unless min_length && max_length

    errors.add(:max_length, "must be greater than min_length") if max_length <= min_length
  end

  def value_validation
    return unless min_value && max_value

    errors.add(:max_value, "must be greater than min_value") if max_value <= min_value
  end
end
