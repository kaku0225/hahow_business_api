# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GraphQL Queries', type: :request do
  def run_query(filename:, variables: nil)
    query = File.read(Rails.root.join('spec', 'fixtures', 'graphql', filename))
    params = { query: query }
    params[:variables] = variables if variables
    post '/graphql',
         params: params.to_json,
         headers: { 'Content-Type' => 'application/json' }
    JSON.parse(response.body)
  end

  describe 'courses' do
    before do
      @c1 = Course.create!(name: 'C1', instructor: 'I1', description: 'D1')
      s1 = @c1.sections.create!(title: 'S1', position: 1)
      s1.units.create!(title: 'U1', content: 'Content1', position: 1)

      @c2 = Course.create!(name: 'C2', instructor: 'I2')
      s2 = @c2.sections.create!(title: 'S2', position: 1)
      s2.units.create!(title: 'U2', content: 'Content2', position: 1)
    end

    it 'returns all courses with nested sections and units' do
      result = run_query(filename: 'courses.graphql')
      data   = result['data']['courses']

      expect(data.size).to eq 2

      found = data.find { |c| c['id'] == @c1.id.to_s }
      expect(found['name']).to eq 'C1'
      expect(found['instructor']).to eq 'I1'
      expect(found['description']).to eq 'D1'
      expect(found['sections'].first['title']).to eq 'S1'
      expect(found['sections'].first['units'].first['title']).to eq 'U1'
    end
  end

  describe 'course(id:)' do
    let!(:course) do
      c = Course.create!(name: 'Solo', instructor: 'Indie', description: 'Desc')
      sec = c.sections.create!(title: 'OnlySec', position: 1)
      sec.units.create!(title: 'OnlyUnit', content: 'SoloContent', position: 1)
      c
    end

    it 'returns the specified course with nested data' do
      result = run_query(
        filename:  'course.graphql',
        variables: { 'id' => course.id.to_s }
      )
      data = result['data']['course']

      expect(data['id']).to eq course.id.to_s
      expect(data['name']).to eq 'Solo'
      expect(data['sections'].size).to eq 1
      expect(data['sections'].first['units'].first['title']).to eq 'OnlyUnit'
    end

    it 'returns null if the course does not exist' do
      result = run_query(
        filename:  'course.graphql',
        variables: { 'id' => '0' }
      )
      expect(result['data']['course']).to be_nil
    end
  end
end
