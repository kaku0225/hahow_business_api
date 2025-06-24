class CreateUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :units do |t|
      t.bigint :section_id, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.text :description
      t.integer :position, null: false

      t.timestamps
    end

    add_index :units, :section_id
  end
end
