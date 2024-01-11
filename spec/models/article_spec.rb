require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @user = User.new(ref: '1')
    @user.save
    @article_post = Article.new(title: 'article title', publisher: 'article publisher', pbulished_year: 1990)
  end

  it 'should have a title' do
    @article_post.title = nil
    expect(@article_post).to_not be_valid
  end
  it 'should have a publisher name' do
    @article_post.publisher = nil
    expect(@article_post).to_not be_valid
  end
  it 'should have a publisher year' do
    @article_post.pbulished_year = nil
    expect(@article_post).to_not be_valid
  end

  it 'should have a publisher year as integer' do
    @article_post.pbulished_year = 'hello'
    expect(@article_post).to_not be_valid
  end
end
