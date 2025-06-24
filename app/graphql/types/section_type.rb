# frozen_string_literal: true

module Types
  class SectionType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :position, Integer, null: false
    field :units, [Types::UnitType], null: false, description: "List of all units under this section"
  end
end
