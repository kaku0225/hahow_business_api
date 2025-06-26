# frozen_string_literal: true

module Resolvers
  class CoursesResolver < Resolvers::BaseResolver
    type [ Types::CourseType ], null: false

    def resolve
      Course.order(:id)
    end
  end
end
