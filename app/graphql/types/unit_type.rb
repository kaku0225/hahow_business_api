# frozen_string_literal: true

module Types
  class UnitType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :content, String, null: false
    field :position, Integer, null: false
  end
end
