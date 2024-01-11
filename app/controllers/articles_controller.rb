class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :current_visitor

  def current_visitor
    @current_visitor ||= User.find_by(id: session[:visitor_id]) || create_current_visitor
  end

  def create_current_visitor
    last_user = User.last
    last_user_id = last_user.nil? ? 0 : last_user.id
    new_user = User.create(ref: last_user_id + 1)
    session[:visitor_id] = new_user.id

    new_user
  end

  # GET /articles or /articles.json
  def index
    if params[:query].present? && params[:query].length > 2
      store_search_history(params[:query])
      @articles = Article.where('lower(title) LIKE ?', "%#{params[:query].downcase}%")
    else
      @articles = Article.all
    end

    if turbo_frame_request?
      render partial: 'articles', locals: { articles: @articles }
    else
      render :index
    end
  end

  def store_search_history(search_data)
    search_history = SearchHistory.where(user: @current_visitor).order('updated_at DESC')
    puts 'Search Data: '
    p search_data
    puts 'Search History: '
    p search_history
    related_result = search_related(search_history, search_data)
    puts 'Related Result: '
    p related_result
    related_result[:db_change] && related_result[:update].update(search_string: search_data)

    related_result[:db_create] ? SearchHistory.create(search_string: search_data, user: @current_visitor) : nil
  end

  def search_related(search_history, search_data)
    search_history.each do |history|
      if history.search_string.strip.downcase.start_with?(search_data.strip.downcase)
        return { db_change: false, db_create: false,
                 update: nil }
      end
      if search_data.strip.downcase.include?(history.search_string.strip.downcase)
        return { db_change: true, db_create: false,
                 update: history }
      end
    end
    { db_change: false, db_create: true, update: nil }
  end

  # GET /articles/1 or /articles/1.json
  def show
    # Add any specific logic for the show action if needed
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    # Add any specific logic for the edit action if needed
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :publisher, :published_year)
  end
end
