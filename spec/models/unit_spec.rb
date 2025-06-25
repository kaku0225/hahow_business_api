# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:course) { Course.create!(name: 'C1', instructor: 'I1') }
  let(:section) { course.sections.create!(title: 'S1', position: 1) }

  describe 'validations' do
    it 'is valid with title and content' do
      unit = section.units.new(title: 'U1', content: 'C1')
      expect(unit).to be_valid
    end

    it 'is invalid without a title' do
      unit = section.units.new(content: 'C1')
      expect(unit).not_to be_valid
      expect(unit.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without content' do
      unit = section.units.new(title: 'U1')
      expect(unit).not_to be_valid
      expect(unit.errors[:content]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a section' do
      unit = section.units.create!(title: 'U1', content: 'C1', position: 1)
      expect(unit.section).to eq(section)
    end
  end

  describe 'acts_as_list ordering' do
    it 'automatically assigns position sequentially' do
      u1 = section.units.create!(title: 'U1', content: 'C1', position: nil)
      u2 = section.units.create!(title: 'U2', content: 'C2', position: nil)
      expect(u1.position).to eq 1
      expect(u2.position).to eq 2
    end

    it 'reorders positions when insert_at is used' do
      u1 = section.units.create!(title: 'U1', content: 'C1', position: nil)
      u2 = section.units.create!(title: 'U2', content: 'C2', position: nil)
      u2.insert_at(1)
      expect(u2.position).to eq 1
      expect(u1.reload.position).to eq 2
    end
  end
end
