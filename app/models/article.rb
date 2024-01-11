class Article < ApplicationRecord
  validates :title, presence: true
  validates :publisher, presence: true
  validates :pbulished_year, presence: true, numericality: { only_integer: true }
end
