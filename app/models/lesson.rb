class Lesson < ApplicationRecord
    belongs_to :category
    has_many :results
    accepts_nested_attributes_for :results
end
