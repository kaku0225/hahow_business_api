class Section < ApplicationRecord
  belongs_to :course
  has_many :units, -> { order(:position) }, dependent: :destroy
  acts_as_list scope: :course
  accepts_nested_attributes_for :units, allow_destroy: true
  validates :title, presence: true
end
