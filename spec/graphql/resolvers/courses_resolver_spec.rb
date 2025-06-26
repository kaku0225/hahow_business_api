# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::CoursesResolver, type: :resolver do
  let(:schema) { HahowBusinessApiSchema }
  let(:query)  { GraphQL::Query.new(schema, "", variables: {}, context: {}) }
  let(:ctx)    { query.context }
  let(:field)  { schema.query.fields["courses"] }

  describe '#resolve' do
    it 'returns all courses with nested sections and units' do
      c = FactoryBot.create(:course) do |course|
        s = course.sections.create!(title: 'Sec1', position: 1)
        s.units.create!(title: 'U1', content: 'C1', position: 1)
      end

      resolver = described_class.new(object: nil, context: ctx, field: field)
      result   = resolver.resolve

      expect(result).to match_array([ c ])
      course_obj = result.first
      expect(course_obj.sections).not_to be_empty
      section = course_obj.sections.first
      expect(section.title).to eq 'Sec1'
      expect(section.units).not_to be_empty
      expect(section.units.first.title).to eq 'U1'
    end
  end
end
