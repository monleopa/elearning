class Category < ApplicationRecord
  has_many :questions
  accepts_nested_attributes_for :questions
  has_many :lessons
  accepts_nested_attributes_for :lessons
end
