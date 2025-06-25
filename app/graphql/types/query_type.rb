# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :courses, resolver: Resolvers::CoursesResolver
    field :course,  resolver: Resolvers::CourseResolver
  end
end
