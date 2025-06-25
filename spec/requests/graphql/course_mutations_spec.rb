# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Course Mutations', type: :request do
  def run_mutation(variables:, filename:)
    query = File.read(Rails.root.join('spec', 'fixtures', 'graphql', filename))
    post '/graphql',
      params: { query: query, variables: variables }.to_json,
      headers: { 'Content-Type' => 'application/json' }
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
      data   = result['data']['createCourse']
      expect(data['errors']).to be_empty
      expect(data['course']['name']).to eq 'Ruby 101'
      expect(data['course']['sections'].first['units'].size).to eq 1
    end
  end

  context 'UpdateCourse' do
    let(:filename) { 'update_course.graphql' }
    let!(:course) do
      Course.create!(
        name:       'Ruby 101',
        instructor: '郭老師',
        description: '原始描述'
      )
    end

    let(:variables) do
      {
        "input" => {
          "courseAttributes" => {
            "id"          => course.id.to_s,
            "name"        => 'Ruby 102',
            "instructor"  => '新講師',
            "description" => '新描述'
          }
        }
      }
    end

    it 'updates an existing course' do
      result = run_mutation(variables: variables, filename: filename)
      data   = result['data']['updateCourse']
      expect(data['errors']).to be_empty
      expect(data['course']['id']).to           eq course.id.to_s
      expect(data['course']['name']).to         eq 'Ruby 102'
      expect(data['course']['instructor']).to   eq '新講師'
      expect(data['course']['description']).to  eq '新描述'
    end
  end

  context 'DeleteCourse' do
    let(:filename) { 'delete_course.graphql' }
    let!(:course) { Course.create!(name: 'Ruby 101', instructor: '郭老師') }

    let(:variables) { { "input" => { "id" => course.id.to_s } } }

    it 'deletes an existing course' do
      result = run_mutation(variables: variables, filename: filename)
      data   = result['data']['deleteCourse']
      expect(data['errors']).to be_empty
      expect(data['success']).to be true
      expect(Course.find_by(id: course.id)).to be_nil
    end

    it 'returns an error when course not found' do
      result = run_mutation(
        variables: { "input" => { "id" => '0' } },
        filename: filename
      )
      data = result['data']['deleteCourse']
      expect(data['success']).to be false
      expect(data['errors']).to include 'Course not found'
    end
  end
end
