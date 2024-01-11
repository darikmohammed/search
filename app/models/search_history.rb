class SearchHistory < ApplicationRecord
  belongs_to :user

  validates :search_string, presence: true
  before_validation :normalize_search_term

  def normalize_search_term
    self.search_string = search_string.downcase
  end
end
