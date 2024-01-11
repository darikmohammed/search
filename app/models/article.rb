class Article < ApplicationRecord
  validates :title, presence: true
  validates :publisher, presence: true
  validates :published_year, presence: true, numericality: { only_integer: true }
end
