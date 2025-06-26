# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :instructor, String, null: false
    field :description, String, null: true
    field :sections, [Types::SectionType], null: false, description: "List of all sections under this course"

    def sections
      dataloader.with(Loaders::AssociationLoader, Course, :sections).load(object)
    end
  end
end
