# frozen_string_literal: true

module Types
  module Inputs
    class CourseInputType < Types::BaseInputObject
      argument :id, ID, required: false
      argument :name, String, required: true
      argument :instructor, String, required: true
      argument :description, String, required: false
      argument :sections_attributes, [ Types::Inputs::SectionInputType ], required: false
    end
  end
end
