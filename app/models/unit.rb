class Unit < ApplicationRecord
  belongs_to :section
  acts_as_list scope: :section
  validates :title, :content, presence: true
end
