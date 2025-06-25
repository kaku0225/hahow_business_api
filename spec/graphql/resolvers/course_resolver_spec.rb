# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::CourseResolver, type: :resolver do
  let(:schema) { HahowBusinessApiSchema }
  let(:query)  { GraphQL::Query.new(schema, "", variables: {}, context: {}) }
  let(:ctx)    { query.context }
  let(:field)  { schema.query.fields["course"] }

  let!(:course) do
    FactoryBot.create(:course) do |c|
      s = c.sections.create!(title: 'S', position: 1)
      s.units.create!(title: 'U', content: 'X', position: 1)
    end
  end

  it 'finds the course by id' do
    resolver = described_class.new(object: nil, context: ctx, field: field)
    res      = resolver.resolve(id: course.id.to_s)

    expect(res).to eq(course)
    expect(res.sections).not_to be_empty
    section = res.sections.first
    expect(section.title).to eq 'S'
    expect(section.units).not_to be_empty
    expect(section.units.first.title).to eq 'U'
  end

  it 'returns nil when not found' do
    resolver = described_class.new(object: nil, context: ctx, field: field)
    res      = resolver.resolve(id: '0')

    expect(res).to be_nil
  end
end
