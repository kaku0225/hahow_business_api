# frozen_string_literal: true
module Loaders
  class AssociationLoader < GraphQL::Dataloader::Source
    # model is the ActiveRecord class (e.g. Section),
    # assoc_name is the symbol of the association (e.g. :units)
    def initialize(model, assoc_name)
      super()
      @model        = model
      @assoc_name   = assoc_name
    end
  
    def fetch(records)
      ::ActiveRecord::Associations::Preloader.new.preload(records, @assoc_name)
      records.map { |record| record.public_send(@association_name) }
    end
  end
end
