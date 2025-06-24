class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.bigint :course_id, null: false
      t.string :title, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :sections, :course_id
  end
end
