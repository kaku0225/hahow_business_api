class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :instructor, null: false
      t.text :description

      t.timestamps
    end
  end
end
