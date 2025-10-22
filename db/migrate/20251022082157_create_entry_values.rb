class CreateEntryValues < ActiveRecord::Migration[8.0]
  def change
    create_table :entry_values do |t|
      t.string :string_value
      t.integer :integer_value
      t.datetime :datetime_value
      t.references :form_entry, null: false, foreign_key: true
      t.references :form_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
