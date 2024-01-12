# spec/controllers/articles_controller_spec.rb

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET #index' do
    let(:search_query) { 'ruby programming' }

    before(:each) do
      get :index, params: { query: search_query }
    end

    it 'stores search query in search history' do
      search_history = SearchHistory.last
      expect(search_history.search_string).to eq(search_query)
    end

    it 'updates existing search history if similar query' do
      get :index, params: { query: 'ruby programming is not good?' }

      existing_query = SearchHistory.last
      expect(existing_query.reload.search_string).to eq('ruby programming is not good?')
    end

    it 'does not update search history if new term already includes existing' do
      get :index, params: { query: 'ruby programm' }
      search_history = SearchHistory.last
      expect(search_history.search_string).to eq(search_query)
    end

    it 'should not update if the similarity is greater than 0.7' do
      get :index, params: { query: 'ruby programming is not good?' }
      get :index, params: { query: 'ruby programming is not god' }
      search_history = SearchHistory.last
      expect(search_history.search_string).to eq('ruby programming is not good?')
    end

    it 'should update if the similarity is greater than 0.7 and the search string is greater or equal than the history' do
      get :index, params: { query: 'ruby programming is not good' }
      get :index, params: { query: 'ruby programming is not good?' }
      search_history = SearchHistory.last
      expect(search_history.search_string).to eq('ruby programming is not good?')
    end

    it 'should not update if the similarity is greater than 0.7 and the search string is less than the history' do
      get :index, params: { query: 'ruby programming is not good?' }
      get :index, params: { query: 'ruby programming is not good' }
      search_history = SearchHistory.last
      expect(search_history.search_string).to eq('ruby programming is not good?')
      expect(search_history.search_string).not_to eq('ruby programming is not good')
    end
  end
end
