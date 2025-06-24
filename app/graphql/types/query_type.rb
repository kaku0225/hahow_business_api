# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :courses, [Types::CourseType], null: false
    def courses
      Course.includes(sections: :units).all
    end

    field :course, Types::CourseType, null: true do
      argument :id, ID, required: true
    end
    def course(id:)
      Course.includes(sections: :units).find_by(id: id)
    end
  end
end
