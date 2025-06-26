# frozen_string_literal: true

class AssociationLoader < GraphQL::Dataloader::Source
  def initialize(model_class, association_name)
    @model_class     = model_class
    @association_name = association_name
  end

  def fetch(records)
    ::ActiveRecord::Associations::Preloader.new.preload(records, @association_name)
    records.map { |record| record.public_send(@association_name) }
  end
end
