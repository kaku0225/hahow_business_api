# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :instructor, String, null: false
    field :description, String, null: true
    field :sections, [Types::SectionType], null: false, description: "課程底下的所有章節列表"
  end
end
