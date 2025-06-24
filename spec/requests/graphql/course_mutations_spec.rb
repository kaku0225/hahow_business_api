# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Course Mutations', type: :request do
  let(:query_string) { File.read(Rails.root.join('spec', 'fixtures', 'graphql', filename)) }

  def run_mutation(variables:, filename:)
    post '/graphql',
    params: { query: query_string, variables: variables }.to_json,
    headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

    JSON.parse(response.body)
  end

  context 'CreateCourse' do
    let(:filename) { 'create_course.graphql' }
    let(:variables) do
      {
        "input" => {
          "courseAttributes" => {
            "name" => "Ruby 101",
            "instructor" => "郭老師",
            "sectionsAttributes" => [
              {
                "title" => "章節一",
                "unitsAttributes" => [
                  { "title" => "單元A", "content" => "內容A" }
                ]
              }
            ]
          }
        }
      }
    end
    it 'creates a course with nested sections and units' do
      result = run_mutation(variables: variables, filename: filename)
      data = result['data']['createCourse']
      expect(data['course']['name']).to eq 'Ruby 101'
      expect(data['course']['sections'].first['units'].size).to eq 1
      expect(data['errors']).to be_empty
    end
  end
end
