# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Section, type: :model do
  let(:course) { Course.create!(name: 'C1', instructor: 'I1') }

  describe 'validations' do
    it 'is valid with a title' do
      section = course.sections.new(title: 'Sec1')
      expect(section).to be_valid
    end

    it 'is invalid without a title' do
      section = course.sections.new
      expect(section).not_to be_valid
      expect(section.errors[:title]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a course' do
      section = course.sections.create!(title: 'S1', position: 1)
      expect(section.course).to eq(course)
    end

    it 'destroys associated units when destroyed' do
      section = course.sections.create!(title: 'S1', position: 1)
      section.units.create!(title: 'U1', content: 'C1', position: 1)
      expect { section.destroy }.to change { Unit.count }.by(-1)
    end
  end

  describe 'nested attributes' do
    it 'allows nested units to be created' do
      section = course.sections.create!(
        title: 'SecNested', position: 1,
        units_attributes: [ { title: 'U1', content: 'Content1' } ]
      )
      expect(section.units.map(&:title)).to include('U1')
    end

    it 'allows nested units to be destroyed' do
      section = course.sections.create!(title: 'SecD', position: 1)
      unit = section.units.create!(title: 'U1', content: 'C1', position: 1)
      section.update!(units_attributes: [ { id: unit.id, _destroy: true } ])
      expect(section.units.map(&:id)).not_to include(unit.id)
    end
  end

  describe 'acts_as_list ordering' do
    it 'automatically assigns position sequentially' do
      s1 = course.sections.create!(title: 'A', position: nil)
      s2 = course.sections.create!(title: 'B', position: nil)
      expect(s1.position).to eq 1
      expect(s2.position).to eq 2
    end

    it 'reorders positions when insert_at is used' do
      s1 = course.sections.create!(title: 'A', position: nil)
      s2 = course.sections.create!(title: 'B', position: nil)
      s2.insert_at(1)
      expect(s2.position).to eq 1
      expect(s1.reload.position).to eq 2
    end
  end
end
