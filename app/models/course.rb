class Course < ApplicationRecord
  has_many :sections, -> { order(:position) }, dependent: :destroy
  accepts_nested_attributes_for :sections, allow_destroy: true
  validates :name, :instructor, presence: true
end
