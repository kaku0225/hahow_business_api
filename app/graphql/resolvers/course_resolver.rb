# frozen_string_literal: true

module Resolvers
  class CourseResolver < Resolvers::BaseResolver
    type Types::CourseType, null: true
    argument :id, ID, required: true

    def resolve(id:)
      Course.includes(sections: :units).find_by(id: id)
    end
  end
end
