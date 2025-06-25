# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    it 'is valid with name and instructor' do
      course = Course.new(name: 'Test Course', instructor: 'Teacher')
      expect(course).to be_valid
    end

    it 'is invalid without a name' do
      course = Course.new(instructor: 'Teacher')
      expect(course).not_to be_valid
      expect(course.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an instructor' do
      course = Course.new(name: 'Test Course')
      expect(course).not_to be_valid
      expect(course.errors[:instructor]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many sections' do
      course = Course.create!(name: 'C1', instructor: 'I1')
      course.sections.create!(title: 'S1', position: 1)
      course.sections.create!(title: 'S2', position: 2)
      expect(course.sections.count).to eq 2
    end

    it 'destroys associated sections when destroyed' do
      course = Course.create!(name: 'C1', instructor: 'I1')
      course.sections.create!(title: 'S1', position: 1)
      expect { course.destroy }.to change { Section.count }.by(-1)
    end
  end

  describe 'nested attributes' do
    it 'allows nested sections to be created' do
      course = Course.create!(
        name: 'Nested', instructor: 'I',
        sections_attributes: [ { title: 'Sec1' } ]
      )
      expect(course.sections.map(&:title)).to include('Sec1')
    end

    it 'allows nested sections to be destroyed' do
      course = Course.create!(
        name: 'Destroy', instructor: 'I',
        sections_attributes: [ { title: 'Sec1' }, { title: 'Sec2' } ]
      )
      section = course.sections.first
      course.update!(sections_attributes: [ { id: section.id, _destroy: true } ])
      expect(course.sections.map(&:id)).not_to include(section.id)
    end
  end
end
