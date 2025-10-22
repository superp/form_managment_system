class CreateFormFields < ActiveRecord::Migration[8.0]
  def change
    create_table :form_fields do |t|
      t.references :form, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
