require 'rails_helper'

RSpec.describe 'Integration', type: :system do
  before(:all) do
    Rails.application.load_seed
  end

  before(:each) do
    @user = User.new(ref: 1)
    @user.save
  end

  describe 'Visit the home page' do
    it 'show the header' do
      visit '/'
      expect(page.body).to include('Articles')
    end

    it 'should redirect to add article page' do
      visit '/'
      find('a', text: 'New article').click
      sleep(0.1)
      expect(current_path).to eq(new_article_path)
    end

    it 'show the search Items' do
      visit '/'
      fill_in 'query',	with: 'How is'
      sleep(0.3)
      expect(page.body).to include('How is Emil Hajric doing?')
    end
  end
end
