# frozen_string_literal: true

module Mutations
  class CreateCourse < BaseMutation
    argument :course_attributes, Types::Inputs::CourseInputType, required: true

    field :course, Types::CourseType, null: true
    field :errors, [String], null: false

    def resolve(course_attributes:)
      course = Course.new(course_attributes.to_h)
      if course.save
        { course: course, errors: [] }
      else
        { course: nil, errors: course.errors.full_messages }
      end
    end
  end
end
