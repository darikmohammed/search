require 'rails_helper'

RSpec.describe SearchHistory, type: :model do
  describe '#search_string' do
    it 'returns the search string' do
      search = SearchHistory.new(search_string: 'test')
      expect(search.search_string).to eq('test')
    end
  end

  describe '#normalize_search_term' do
    let(:search_history) { SearchHistory.new(search_string: 'Hello WORLD') }

    it 'converts search term to lowercase' do
      search_history.normalize_search_term
      expect(search_history.search_string).to eq('hello world')
    end
    # Test with multiple words
    it 'handles multiple words properly' do
      search_history.search_string = 'Hello WORLD, How are YOU?'
      search_history.normalize_search_term
      expect(search_history.search_string).to eq('hello world, how are you?')
    end

    # Test with special characters
    it 'handles special characters properly' do
      search_history.search_string = 'Hello!!! #World@'
      search_history.normalize_search_term
      expect(search_history.search_string).to eq('hello!!! #world@')
    end

    # Test with nil search term
    it 'handles nil search term' do
      search_history.search_string = nil
      expect { search_history.normalize_search_term }.not_to raise_error
    end

    # Test with blank search term
    it 'handles blank search term' do
      search_history.search_string = ''
      search_history.normalize_search_term
      expect(search_history.search_string).to eq('')
    end
  end
end
