# frozen_string_literal: true

module Mutations
  class UpdateCourse < BaseMutation
    argument :course_attributes, Types::Inputs::CourseInputType, required: true

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(course_attributes:)
      attrs = course_attributes.to_h
      course = Course.find_by(id: attrs.delete("id"))
      return { course: nil, errors: ["Course not found"] } unless course

      if course.update(attrs)
        { course: course, errors: [] }
      else
        { course: nil, errors: course.errors.full_messages }
      end
    end
  end
end
