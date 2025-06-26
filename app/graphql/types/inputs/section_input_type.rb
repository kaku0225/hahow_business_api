# frozen_string_literal: true

module Types
  module Inputs
    class SectionInputType < Types::BaseInputObject
      argument :id, ID, required: false
      argument :title, String, required: true
      argument :position, Integer, required: false, default_value: nil
      argument :_destroy, Boolean, required: false
      argument :units_attributes, [ Types::Inputs::UnitInputType ], required: false
    end
  end
end
