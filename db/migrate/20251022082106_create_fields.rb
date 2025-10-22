class CreateFields < ActiveRecord::Migration[8.0]
  def change
    create_table :fields do |t|
      t.string :name
      t.integer :field_type, null: false, default: 0
      t.integer :min_length
      t.integer :max_length
      t.integer :min_value
      t.integer :max_value
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
