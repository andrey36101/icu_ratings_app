class ArticlesController < ApplicationController
  load_resource except: ["index", "create"]
  authorize_resource

  def index
    params[:create] = can?(:create, Article)
    @articles = Article.search(params, articles_path)
    render :results if request.xhr?
  end

  def show
    respond_to do |format|
      format.html
      format.text { render text: @article.story }
    end
  end

  def new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if params[:commit] == "Cancel"
      redirect_to articles_path
    elsif @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render action: "new"
    end
  end

  def update
    if params[:commit] == "Cancel"
      redirect_to @article
    elsif @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end
  
  private
  
  def article_params
    params.require(:article).permit(:headline, :identity, :published, :story)
  end
end
