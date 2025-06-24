# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_course, mutation: Mutations::CreateCourse
    field :update_course, mutation: Mutations::UpdateCourse
    field :delete_course, mutation: Mutations::DeleteCourse
  end
end
