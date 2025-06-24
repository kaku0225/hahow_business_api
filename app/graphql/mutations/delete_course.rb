# frozen_string_literal: true

module Mutations
  class DeleteCourse < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      course = Course.find_by(id: id)
      return { success: false, errors: ["Course not found"] } unless course

      if course.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: course.errors.full_messages }
      end
    end
  end
end
