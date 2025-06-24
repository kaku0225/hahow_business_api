# frozen_string_literal: true

module Types
  module Inputs
    class UnitInputType < Types::BaseInputObject
      argument :id, ID, required: false
      argument :title, String, required: true
      argument :content, String, required: true
      argument :description, String, required: false
      argument :position, Integer, required: false, default_value: nil
      argument :_destroy, Boolean, required: false
    end
  end
end
