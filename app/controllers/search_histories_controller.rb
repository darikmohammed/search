class SearchHistoriesController < ApplicationController
  def index
    @search_histories = SearchHistory.includes(:user).order(updated_at: :desc)

    # Check for nil before accessing user
    @search_histories.each do |search_history|
      if search_history.user.nil?
        # Handle the case where the user is not present (perhaps log a message or take some action)
        puts "User is not present for SearchHistory with ID: #{search_history.id}"
      else
        # Now it's safe to access user
        p search_history.user
      end
    end
  end
end
